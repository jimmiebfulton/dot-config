# Manage the consolidated cargo build cache.
#
# `build.build-dir` in ~/work/.cargo/config.toml and ~/personal/.cargo/config.toml
# redirects every workspace's intermediate artifacts to
#
#     <scope root>/{workspace-path-hash}
#
# Each scope root is read from that config rather than hardcoded, since roots
# move and differ between machines. Cargo fans the hash out as
# <2-char>/<14-char>, so a workspace build dir sits two levels below each scope
# root. Final artifacts still land in the workspace's own ./target, which this
# tool never touches.
#
# The hash covers the *workspace path*, so every jj workspace of a project gets
# its own complete build dir and shares nothing with its siblings. `report`
# groups those under `project` so the real per-project cost is visible.
#
# Start with `help cargo-gc`; `help cargo-gc status` explains when deletion is
# safe.

const SCOPES = ["work" "personal"]

# Things that may hold a build dir open. Cargo takes an exclusive flock on
# <build-dir>/<profile>/.cargo-build-lock (.cargo-lock on the old layout) for
# the duration of a build, which is what makes deletion unsafe mid-build.
const BUILDERS = ["cargo" "rustc" "rustdoc" "rust-analyzer" "clippy-driver" "cargo-nextest" "cargo-clippy"]

# ------------------------------------------------------------------- helpers

def sum-bytes [] { if ($in | is-empty) { 0b } else { $in | math sum } }

# ----------------------------------------------------------------- discovery

# A scope's build root: build.build-dir from ~/<scope>/.cargo/config.toml with
# its trailing /{workspace-path-hash} removed. Empty when the scope has no
# config, or its build-dir doesn't use that layout.
def scope-root [scope: string] {
  let config   = ([$nu.home-dir $scope ".cargo" "config.toml"] | path join)
  let template = (try { open $config | get build.build-dir } catch { "" })
  if not ($template | str ends-with "/{workspace-path-hash}") { return "" }
  $template | str replace "/{workspace-path-hash}" "" | path expand
}

# Scopes whose build root is configured and present on this machine.
def scope-roots [] {
  $SCOPES
  | each {|scope| { scope: $scope, root: (scope-root $scope) } }
  | where {|s| ($s.root | is-not-empty) and ($s.root | path exists) }
}

# Every <scope root>/<2-char>/<14-char> workspace build dir that exists.
def build-dirs [] {
  scope-roots | each {|s|
    ls $s.root | where type == dir | each {|bucket|
      ls $bucket.name | where type == dir | each {|ws|
        {
          scope: $s.scope
          hash:  $"($bucket.name | path basename)($ws.name | path basename)"
          path:  $ws.name
        }
      }
    } | flatten
  } | flatten
}

# ---------------------------------------------------------------------- size

# `du -k -d 2` rather than nushell's `du`: cargo hardlinks aggressively inside
# a build dir (~88% of files here have nlink > 1) and nushell's `du` counts
# every link, overstating reclaimable space by ~50%. BSD du dedups by inode.
# Depth 2 also yields the per-profile `incremental` totals from the same walk.
def measure [dir: path] {
  if not ($dir | path exists) { return { size: 0b, incr: 0b } }
  let out = (^du -k -d 2 $dir | complete)
  if $out.exit_code != 0 { return { size: 0b, incr: 0b } }

  let rows = ($out.stdout | lines | where {|l| $l | is-not-empty } | each {|l|
    let parts = ($l | split row (char tab))
    {
      kb:   (try { $parts | first | str trim | into int } catch { 0 })
      path: ($parts | last | str trim)
    }
  })
  if ($rows | is-empty) { return { size: 0b, incr: 0b } }

  # du prints the argument itself last.
  let total = ($rows | last | get kb)
  let incr  = ($rows | where {|r| ($r.path | path basename) == "incremental" } | get kb | sum-bytes)
  { size: (($total * 1024) | into filesize), incr: (($incr * 1024) | into filesize) }
}

def incremental-dirs [dir: path] {
  glob ($dir | path join "*" "incremental")
}

# -------------------------------------------------------------- last touched

# Newest mtime among the build dir's sentinel entries: .rustc_info.json, the
# per-profile lock files, and the profile subdirectories themselves (whose
# mtimes move whenever cargo adds or removes an entry). Verified to match a
# full recursive scan on every build dir here, at a fraction of the cost.
def last-touch [dir: path] {
  let top   = (try { ls --all $dir } catch { [] })
  let inner = ($top | where type == dir | get name | each {|p|
    try { ls --all $p } catch { [] }
  } | flatten)
  let times = ([...$top ...$inner] | get modified? | compact)
  if ($times | is-empty) {
    (ls --directory $dir | get modified | first)
  } else {
    $times | math max
  }
}

# -------------------------------------------------------------------- origin

def src-regex [] {
  $nu.home-dir + '/(' + ($SCOPES | str join '|') + ')/[A-Za-z0-9._+@-]+(/[A-Za-z0-9._+@-]+)*'
}

# Recover one absolute path into the originating workspace.
#
# NOTE: dep-info (.d) files record *relative* paths for workspace-local
# sources, so the first field of a .d line is useless on its own. The only
# reliable signal is an absolute path landing under ~/work or ~/personal.
def recorded-src [dir: path] {
  let re = (src-regex)

  # 1. dep-info files: cheap and structured, resolves most build dirs.
  #    `| ^head -1` matters: it SIGPIPEs rg after the first hit instead of
  #    letting it scan the whole tree (0.06s vs 0.79s on a 75 GB dir).
  let hit = (try {
    ^rg -a -I --no-messages -o -m1 --glob '*.d' $re $dir | ^head -1 | lines | get 0?
  } catch { null })
  if ($hit | is-not-empty) { return $hit }

  # 2. incremental session files: catches dirs where only dependencies were
  #    ever compiled, so no workspace-local .d file exists.
  let incr = (incremental-dirs $dir)
  if ($incr | is-empty) { return "" }
  let sample = (try { ^fd --type f --max-results 300 . ...$incr | lines } catch { [] })
  if ($sample | is-empty) { return "" }
  let hit2 = (try {
    ^rg -a -I --no-messages -o -m1 $re ...$sample | ^head -1 | lines | get 0?
  } catch { null })
  if ($hit2 | is-not-empty) { return $hit2 }

  ""
}

# Resolve a recorded path to the workspace root that owns it: climb to the
# deepest ancestor that still exists, then to the *topmost* Cargo.toml at or
# above it (bounded by ~/work and ~/personal) so we land on the workspace
# root rather than a member crate. Empty result => the source tree is gone.
def workspace-root-of [recorded: string] {
  if ($recorded | is-empty) { return "" }
  let bounds = ($SCOPES | each {|s| ([$nu.home-dir $s] | path join) })

  mut cur = $recorded
  while (not ($cur | path exists)) {
    let up = ($cur | path dirname)
    if $up == $cur { break }
    $cur = $up
  }
  if not ($cur | path exists) { return "" }
  if ($cur | path type) == "file" { $cur = ($cur | path dirname) }

  mut best = ""
  mut probe = $cur
  loop {
    let p = $probe
    if (([$p "Cargo.toml"] | path join) | path exists) { $best = $p }
    if ($bounds | any {|b| $b == $p }) { break }
    let up = ($p | path dirname)
    if $up == $p { break }
    $probe = $up
  }
  $best
}

# Group jj workspaces of one repo under a single project name. A secondary jj
# workspace has .jj/repo as a *file* pointing at the main workspace's repo.
def project-of [ws: string] {
  if ($ws | is-empty) { return "?" }
  let repo = ([$ws ".jj" "repo"] | path join)
  if not ($repo | path exists) { return ($ws | path basename) }
  if ($repo | path type) == "dir" { return ($ws | path basename) }
  let target = (try { open --raw $repo | str trim } catch { "" })
  if ($target | is-empty) { return ($ws | path basename) }
  ([$ws ".jj" $target] | path join | path expand | path dirname | path dirname | path basename)
}

# Origins only, no sizes or lock checks -- cheap enough (~0.5s) to drive tab
# completion for --only.
def origins [] {
  build-dirs | each {|d|
    let root = (workspace-root-of (recorded-src $d.path))
    { project: (project-of $root), name: (if ($root | is-empty) { "" } else { $root | path basename }) }
  }
}

def project-names [] {
  origins | each {|o| [$o.project $o.name] } | flatten | where {|n| $n | is-not-empty } | uniq | sort
}

# -------------------------------------------------------------------- safety

def lock-files [dir: path] {
  (glob ($dir | path join "*" ".cargo-lock"))
  | append (glob ($dir | path join "*" ".cargo-build-lock"))
}

# True when something currently holds this build dir's cargo lock open.
def in-use [dir: path] {
  let locks = (lock-files $dir)
  if ($locks | is-empty) { return false }
  let out = (^lsof ...$locks | complete)
  ($out.stdout | str trim | is-not-empty)
}

def active-builders [] {
  ps | where {|p| $BUILDERS | any {|b| $p.name == $b } }
}

# ------------------------------------------------------------------ reporting

# List every workspace build dir with its size, age and origin, as data.
#
# Columns:
#   scope      work | personal, from the .cargo/config.toml that produced it
#   project    repo the workspace belongs to; jj workspaces of one repo share it
#   name       workspace directory name
#   workspace  absolute path to the source workspace
#   size       on-disk size, hardlink-deduped
#   incr       the incremental/ portion of `size` -- what `trim` reclaims
#   last       when cargo last touched this dir
#   touched    the same, as a datetime, for filtering
#   state      live    -- the source workspace is present
#              orphan  -- a source path was recorded but is gone; safe to sweep
#              unknown -- no source path recoverable; only --days removes it
#   stale      true when `touched` is older than --days
#   locked     a build holds this dir's cargo lock right now
#   hash       cargo's {workspace-path-hash}
#   path       the build dir itself
#
# Origins are inferred from absolute source paths cargo recorded inside the
# build dir. That is a heuristic; `cargo-gc verify` checks it against cargo.
@category "filesystem"
@search-terms "cargo" "rust" "disk" "cache" "build" "jj"
@example "biggest first" "cargo-gc report | select project name size"
@example "just the reclaimable ones" "cargo-gc report | where state != live"
@example "custom idle threshold" "cargo-gc report --days 7 | where stale"
export def report [
  --days: int = 30  # idle threshold in days; sets the `stale` column
]: nothing -> table {
  let cutoff = ((date now) - ($days * 1day))

  build-dirs | each {|d|
    let recorded = (recorded-src $d.path)
    let root     = (workspace-root-of $recorded)
    let touched  = (last-touch $d.path)
    let m        = (measure $d.path)
    {
      scope:     $d.scope
      project:   (project-of $root)
      name:      (if ($root | is-not-empty) {
                    $root | path basename
                  } else if ($recorded | is-not-empty) {
                    try { $recorded | path relative-to $nu.home-dir } catch { $recorded }
                  } else {
                    $"?($d.hash)"
                  })
      workspace: (if ($root | is-empty) { $recorded } else { $root })
      size:      $m.size
      incr:      $m.incr
      last:      ($touched | date humanize)
      touched:   $touched
      state:     (if ($root | is-not-empty) { "live" } else if ($recorded | is-not-empty) { "orphan" } else { "unknown" })
      stale:     ($touched < $cutoff)
      locked:    (in-use $d.path)
      hash:      $d.hash
      path:      $d.path
    }
  } | sort-by size --reverse
}

# Show what the cargo build cache is holding, by workspace and by project.
#
# Subcommands:
#   cargo-gc report    the same rows as data, for filtering and scripting
#   cargo-gc status    what is building right now, and what that blocks
#   cargo-gc verify    check the recovered origins against cargo itself
#   cargo-gc trim      delete incremental caches only   (safest reclaim)
#   cargo-gc sweep     delete whole build dirs          (orphaned or idle)
#
# Reclaim in order of increasing regret:
#   trim                    costs one slower build
#   sweep --orphans-only    the source workspace is gone; costs nothing
#   sweep --days N          costs a full rebuild of anything idle that long
#
# A build dir is unsafe to delete only while cargo holds its lock. trim and
# sweep check that per directory and skip whatever is busy, so both are safe
# to run at any time -- see `help cargo-gc status`.
@category "filesystem"
@search-terms "cargo" "rust" "disk" "cache" "build" "space" "jj" "gc"
@example "what is using the space" "cargo-gc"
@example "treat two weeks as idle" "cargo-gc --days 14"
export def main [
  --days: int = 30  # idle threshold in days for the summary's `idle >Nd` line
]: nothing -> nothing {
  let rows = (report --days $days)
  if ($rows | is-empty) { print "no cargo build dirs found"; return }

  print ($rows | select project name size incr last state)
  let locked = ($rows | where locked)
  if ($locked | is-not-empty) {
    print $"in use right now: ($locked | get name | str join ', ')"
  }

  print ""
  print "by project:"
  print ($rows
    | group-by project
    | items {|proj rs| {
        project:    $proj
        workspaces: ($rs | length)
        size:       ($rs | get size | sum-bytes)
        incr:       ($rs | get incr | sum-bytes)
      }}
    | sort-by size --reverse)

  print ""
  print $"total          ($rows | get size | sum-bytes)"
  print $"  incremental  ($rows | get incr | sum-bytes)   -> `cargo-gc trim`, always safe"
  print $"  idle >($days)d     ($rows | where stale | get size | sum-bytes)   -> `cargo-gc sweep --days ($days)`"
  print $"  orphaned     ($rows | where state == orphan | get size | sum-bytes)   -> source workspace is gone"
}

# Report what is building right now, and what that blocks.
#
# Cargo takes an exclusive lock on <build-dir>/<profile>/.cargo-build-lock
# (.cargo-lock on the older layout) and holds it for the whole build. That
# lock is the only thing that makes deletion genuinely unsafe: removing a
# build dir mid-build leaves cargo writing into a tree that is vanishing
# underneath it.
#
# So safety is per directory, not per machine. A build running in one jj
# workspace says nothing about whether another project's build dir can go.
# trim and sweep re-check the lock immediately before each delete and skip
# whatever is busy; --strict instead turns any build process anywhere into a
# hard refusal.
#
# Deleting an unlocked dir is always recoverable: an incremental cache costs
# one slower build, a whole build dir costs a full rebuild. The workspace's
# own ./target and its sources are never touched.
#
# Deliberately cheap -- this does not measure sizes.
@category "filesystem"
@search-terms "cargo" "lock" "safe" "busy" "build"
@example "check before reclaiming" "cargo-gc status"
export def status []: nothing -> nothing {
  let busy   = (active-builders)
  let locked = (build-dirs | where {|d| in-use $d.path })

  if ($busy | is-not-empty) {
    print $"BUSY: ($busy | length) build process\(es\) running"
    print ($busy | select pid name cpu)
  } else {
    print "ok: no cargo/rustc/rust-analyzer process running"
  }

  if ($locked | is-not-empty) {
    print $"BUSY: ($locked | length) build dir\(s\) hold a live cargo lock"
    print ($locked | select scope hash path)
  } else {
    print "ok: no build dir holds a live cargo lock"
  }

  print ""
  if ($locked | is-empty) {
    print "safe: every build dir can be reclaimed right now"
  } else {
    print "sweep/trim will skip the locked dirs and reclaim the rest"
  }
}

# Check each recovered origin against cargo's own build_directory.
#
# `report` infers a build dir's origin from source paths cargo left inside it.
# This runs `cargo metadata` in every live workspace and compares the
# build_directory cargo reports to the dir we attributed to it. `ok` false
# means that row's project/workspace columns should not be trusted -- and in
# particular that its `orphan` or `unknown` state is not evidence of anything.
#
# Runs inside each workspace rather than passing --manifest-path, because
# cargo resolves .cargo/config.toml from the current directory.
@category "filesystem"
@search-terms "cargo" "metadata" "origin" "check"
@example "confirm the origin map" "cargo-gc verify"
@example "only the disagreements" "cargo-gc verify | where not ok"
export def verify []: nothing -> table {
  report | each {|r|
    if $r.state != "live" {
      { project: $r.project, name: $r.name, cargo: "-", ok: false }
    } else {
      let got = (try {
        cd $r.workspace
        ^cargo metadata --no-deps --offline --format-version 1 | from json | get build_directory
      } catch { "" })
      { project: $r.project, name: $r.name, cargo: $got, ok: ($got == $r.path) }
    }
  }
}

# ------------------------------------------------------------------ deletion

# Cargo's two-level hash fan-out leaves an empty <2-char> bucket behind once
# its only workspace dir is gone.
def prune-buckets [] {
  scope-roots | each {|s|
    ls $s.root | where type == dir | each {|b|
      if ((ls $b.name | length) == 0) { rm --recursive --force $b.name }
    }
  } | ignore
}

# --only substring match against the project or workspace name.
def pick [rows: list, only: string] {
  if ($only | is-empty) { return $rows }
  $rows | where {|r| ($r.project | str contains $only) or ($r.name | str contains $only) }
}

def confirm [what: string, yes: bool] {
  if $yes { return true }
  let answer = (input $"delete ($what)? [y/N] ")
  ($answer | str lowercase | str starts-with "y")
}

# Cargo is running somewhere on this machine almost continuously, so a global
# refusal would make the tool unusable. The real gate is per build dir (the
# cargo lock); this only decides whether to warn or, under --strict, stop.
def builder-note [strict: bool] {
  let busy = (active-builders)
  if ($busy | is-empty) { return true }
  let names = ($busy | get name | uniq | str join ', ')
  if $strict {
    print $"refusing \(--strict\): ($names) running"
    false
  } else {
    print $"note: ($names) running - dirs holding a live cargo lock will be skipped"
    true
  }
}

# Re-check the lock, then move the directory aside before deleting it. The
# rename is atomic within the filesystem, so a build that starts mid-delete
# creates a fresh directory instead of racing a half-deleted tree.
def reclaim [dir: path, owner: path] {
  if (in-use $owner) { return false }
  let tomb = $"($dir).gc-tomb"
  if ($tomb | path exists) { rm --recursive --force $tomb }
  try { mv $dir $tomb } catch { return false }
  rm --recursive --force $tomb
  true
}

# Delete incremental compilation caches, keeping the build dirs themselves.
#
# rustc's incremental cache is pure derived state: dropping it costs one
# slower build and nothing else. It is often half the total, and unlike
# sweeping by age it reclaims space from workspaces you are actively using --
# which is usually where the space actually is.
#
# Dirs holding a live cargo lock are skipped.
@category "filesystem"
@search-terms "cargo" "incremental" "cache" "reclaim" "space"
@example "see what it would free" "cargo-gc trim --dry-run"
@example "reclaim it all" "cargo-gc trim"
@example "one project only" "cargo-gc trim --only substrate"
@example "leave this week's work alone" "cargo-gc trim --days 7"
export def trim [
  --days: int = 0                    # only trim dirs idle this long; 0 trims every one
  --only: string@project-names = ""  # limit to workspaces whose project or name contains this
  --dry-run                          # list what would be deleted, then stop
  --strict                           # refuse to run at all if any build process is running
  --yes                              # skip the confirmation prompt
]: nothing -> nothing {
  if ((not $dry_run) and (not (builder-note $strict))) { return }

  let rows = (pick (report --days $days) $only
    | where {|r| (not $r.locked) and $r.stale and ($r.incr > 0b) })

  if ($rows | is-empty) { print "no incremental caches to trim"; return }

  print ($rows | select project name incr last state)
  print $"reclaiming ($rows | get incr | sum-bytes)"

  if $dry_run { print "\(dry run - nothing deleted)"; return }
  if not (confirm $"($rows | length) incremental cache\(s\)" $yes) { print "aborted"; return }

  let done = ($rows | each {|r|
    let ok = (incremental-dirs $r.path | each {|d| reclaim $d $r.path } | all {|x| $x })
    { name: $r.name, freed: (if $ok { $r.incr } else { 0b }), ok: $ok }
  })
  let skipped = ($done | where {|d| not $d.ok })
  if ($skipped | is-not-empty) {
    print $"skipped \(became busy): ($skipped | get name | str join ', ')"
  }
  print $"freed ($done | get freed | sum-bytes)"
}

# Delete whole build dirs that are orphaned or idle.
#
# A dir is selected when either its source workspace is gone (state orphan,
# always safe) or it has not been touched in --days. Dirs whose origin could
# not be recovered at all (state unknown) are never selected by
# --orphans-only, only by --days.
#
# Dirs holding a live cargo lock are skipped. Each deletion moves the
# directory aside with an atomic rename before removing it, so a build that
# starts mid-delete gets a fresh dir rather than a half-deleted one. Empty
# <2-char> buckets left by cargo's fan-out are pruned afterwards.
#
# The workspace's own ./target is never touched; anything deleted here costs
# a rebuild, nothing more.
@category "filesystem"
@search-terms "cargo" "reclaim" "space" "orphan" "stale" "prune"
@example "always start here" "cargo-gc sweep --days 14 --dry-run"
@example "reclaim dirs idle for two weeks" "cargo-gc sweep --days 14"
@example "only workspaces that no longer exist" "cargo-gc sweep --orphans-only"
@example "refuse if anything at all is building" "cargo-gc sweep --days 30 --strict"
export def sweep [
  --days: int = 30                   # delete dirs untouched for this many days
  --only: string@project-names = ""  # limit to workspaces whose project or name contains this
  --dry-run                          # list what would be deleted, then stop
  --strict                           # refuse to run at all if any build process is running
  --yes                              # skip the confirmation prompt
  --orphans-only                     # only dirs whose source workspace is gone; ignore --days
]: nothing -> nothing {
  if ((not $dry_run) and (not (builder-note $strict))) { return }
  if (not $dry_run) { prune-buckets }

  let rows = (pick (report --days $days) $only)
  let doomed = ($rows | where {|r|
    (not $r.locked) and (($r.state == "orphan") or ((not $orphans_only) and $r.stale))
  })

  let locked = ($rows | where locked)
  if ($locked | is-not-empty) {
    print $"skipping ($locked | length) locked build dir\(s\): ($locked | get name | str join ', ')"
  }
  if ($doomed | is-empty) { print "nothing to reclaim"; return }

  print ($doomed | select project name workspace size last state)
  print $"reclaiming ($doomed | get size | sum-bytes)"

  if $dry_run { print "\(dry run - nothing deleted)"; return }
  if not (confirm $"($doomed | length) build dir\(s\)" $yes) { print "aborted"; return }

  let done = ($doomed | each {|r|
    let ok = (reclaim $r.path $r.path)
    { name: $r.name, freed: (if $ok { $r.size } else { 0b }), ok: $ok }
  })
  let skipped = ($done | where {|d| not $d.ok })
  if ($skipped | is-not-empty) {
    print $"skipped \(became busy): ($skipped | get name | str join ', ')"
  }
  print $"freed ($done | get freed | sum-bytes)"
}
