{ config, pkgs, lib, ... }:

# Keeps /Volumes/AIML usable, invariantly, with no grant, no signature and no daemon.
# User, 2026-10-27 (beekeeper mail:3676/3734): "I want this disk usable ... solved
# permanently and invariantly."
#
# ~/personal/.cargo/config.toml points every cargo build outside a Substrate pool slot at
#   build-dir = "/Volumes/AIML/cargo-build/personal/{workspace-path-hash}"
# so each workspace grows its own full build dir there (70-450 GiB each). Nothing else
# reclaimed them; on 2026-10-26 they held 2.4 TB and blocked landings at the 1000 GiB floor.
#
# Reach: an ALLOW list of two roots under /Volumes/AIML/cargo-build, nothing else:
#   personal/<xx>/<hash>  one workspace build dir: deleted whole.
#   pool/<n>              one Substrate build-pool slot: its CONTENTS are deleted, the slot
#                         dir stays (the pool expects it). Costs that slot one cold build.
# Never models, never sccache (capped at 60G), never anything else on the volume.
# A host without /Volumes/AIML/cargo-build logs a refusal and does nothing.
#   age:      a build dir or pool slot with no file written in 24h is reaped.
#   pressure: while the volume has < 1100 GiB free, personal dirs idle >= 2h go until
#             >= 1200 GiB. Still under 1100 after that: a macOS notification (ALERT), since
#             every remaining build dir is in use.
let
  log = "${config.home.homeDirectory}/Library/Logs/cargo-reap.log";
  reap = pkgs.writeShellScript "cargo-reap" ''
    set -u
    BASE=/Volumes/AIML/cargo-build
    ROOT=$BASE/personal
    POOL=$BASE/pool
    VOL=/Volumes/AIML
    IDLE_HOURS=24
    PRESS_HOURS=2
    LOW_GIB=1100
    HIGH_GIB=1200
    LOCK=/tmp/cargo-reap.lock
    log() { echo "$(date -u +%FT%TZ) $*"; }
    free_gib() { /bin/df -g "$VOL" | /usr/bin/awk 'NR==2 {print $4}'; }
    notify() {
      /usr/bin/osascript -e "display notification \"$1\" with title \"cargo-reap: /Volumes/AIML\" sound name \"Basso\"" 2>/dev/null || true
    }

    if [ ! -d "$BASE" ] || [ -L "$BASE" ]; then log "refuse: $BASE missing or a symlink"; exit 0; fi
    mkdir "$LOCK" 2>/dev/null || { log "skip: another reap holds $LOCK"; exit 0; }
    trap 'rmdir "$LOCK"' EXIT

    idle_for() { [ -z "$(/usr/bin/find "$1" -type f -newermt "-$2 hours" -print -quit 2>/dev/null)" ]; }
    reap() {
      case "$1" in "$ROOT"/??/*) ;; *) log "refuse: $1 is outside $ROOT/<xx>/<hash>"; return;; esac
      rm -rf -- "$1" && log "deleted $1 ($2)" || log "FAILED $1"
    }
    reap_slot() {
      case "$1" in "$POOL"/[0-9]*) ;; *) log "refuse: $1 is not a pool slot $POOL/<n>"; return;; esac
      if [ -z "$(/bin/ls -A "$1" 2>/dev/null)" ]; then return; fi
      /usr/bin/find "$1" -mindepth 1 -maxdepth 1 -exec rm -rf -- {} + && log "emptied pool slot $1 ($2)" || log "FAILED $1"
    }

    before=$(free_gib)
    log "start: $before GiB free"
    if [ -d "$ROOT" ] && [ ! -L "$ROOT" ]; then
      for d in "$ROOT"/??/*/; do
        d=''${d%/}
        if [ -d "$d" ] && [ ! -L "$d" ] && idle_for "$d" "$IDLE_HOURS"; then reap "$d" "idle >= $IDLE_HOURS h"; fi
      done
    fi
    if [ -d "$POOL" ] && [ ! -L "$POOL" ]; then
      for s in "$POOL"/[0-9]*/; do
        s=''${s%/}
        if [ -d "$s" ] && [ ! -L "$s" ] && idle_for "$s" "$IDLE_HOURS"; then reap_slot "$s" "idle >= $IDLE_HOURS h"; fi
      done
    fi
    if [ "$(free_gib)" -lt "$LOW_GIB" ] && [ -d "$ROOT" ]; then
      log "pressure: $(free_gib) GiB < $LOW_GIB; reaping dirs idle >= $PRESS_HOURS h"
      for d in "$ROOT"/??/*/; do
        [ "$(free_gib)" -ge "$HIGH_GIB" ] && break
        d=''${d%/}
        if [ -d "$d" ] && [ ! -L "$d" ] && idle_for "$d" "$PRESS_HOURS"; then reap "$d" "pressure, idle >= $PRESS_HOURS h"; fi
      done
    fi
    if [ "$(free_gib)" -lt "$LOW_GIB" ]; then
      log "ALERT: still $(free_gib) GiB free after reaping; every remaining build dir is in use"
      notify "Only $(free_gib) GiB free after reaping. Every build dir is in use; see ~/Library/Logs/cargo-reap.log"
    fi
    [ -d "$ROOT" ] && /usr/bin/find "$ROOT" -mindepth 1 -maxdepth 1 -type d -empty -delete 2>/dev/null
    log "end: $(free_gib) GiB free (was $before)"
  '';
in
{
  launchd.agents.cargo-reap = {
    enable = true;
    config = {
      ProgramArguments = [ "${reap}" ];
      StartInterval = 3600;
      RunAtLoad = true;
      ProcessType = "Background";
      LowPriorityIO = true;
      StandardOutPath = log;
      StandardErrorPath = log;
    };
  };
}
