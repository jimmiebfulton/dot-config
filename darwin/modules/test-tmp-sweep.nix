{ config, pkgs, lib, ... }:

# Bounds the scratch space that cargo-run tests leave behind.
#
# ~/work/.cargo/config.toml and ~/personal/.cargo/config.toml force
#   [env] TMPDIR = { value = "<home>/.cache/test-tmp", force = true }
# so every test, build script and `cargo run` binary under those trees writes
# its temp files here instead of the shared macOS $TMPDIR. Tests leak their
# sandboxes whenever cleanup never runs (mem::forget, TempDir::keep, a nextest
# timeout kill), and on 2026-09-13 ~70k of them filled the disk (~1 TB).
#
# Hourly, top-level entries untouched for 2h that no process holds open are
# removed. The directory is recreated on every run: tempfile fails outright
# when TMPDIR does not exist.
let
  root = "${config.home.homeDirectory}/.cache/test-tmp";
  log = "${config.home.homeDirectory}/Library/Logs/test-tmp-sweep.log";
  sweep = pkgs.writeShellScript "test-tmp-sweep" ''
    set -eu
    root=${lib.escapeShellArg root}
    mkdir -p "$root"
    work=$(mktemp -d)
    trap 'rm -rf "$work"' EXIT

    ${pkgs.fd}/bin/fd -H -I --max-depth 1 --changed-before 2h . "$root" \
      | sed 's|/$||' | sort > "$work/stale"
    /usr/sbin/lsof -Fn 2>/dev/null \
      | sed -n "s|^n\($root/[^/]*\).*|\1|p" | sort -u > "$work/open"
    comm -23 "$work/stale" "$work/open" > "$work/doomed"

    tr '\n' '\0' < "$work/doomed" | xargs -0 rm -rfx || true
    echo "$(date '+%F %T') removed $(wc -l < "$work/doomed" | tr -d ' ') of $(wc -l < "$work/stale" | tr -d ' ') stale, $(wc -l < "$work/open" | tr -d ' ') held open"
  '';
in
{
  launchd.agents.test-tmp-sweep = {
    enable = true;
    config = {
      ProgramArguments = [ "${sweep}" ];
      StartInterval = 3600;
      RunAtLoad = true;
      ProcessType = "Background";
      LowPriorityIO = true;
      StandardOutPath = log;
      StandardErrorPath = log;
    };
  };
}
