# config.nu

use std/dirs;

$env.config.edit_mode = 'vi' 
$env.config.table.mode = 'compact'
$env.config.buffer_editor = "nvim"
$env.config.show_banner = false

$env.EDITOR = "nvim"
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
$env.JJ_CONFIG = $"/Users/jimmie/.config/jj/config.toml"
$env.PNPM_HOME = $"/Users/jimmie/bin"
$env.OLLAMA_KEEP_ALIVE = "-1"

if ("~/.config/nushell/local.nu" | path exists) {
  source "~/.config/nushell/local.nu"
}

source keybindings.nu

$env.config = {
  keybindings: $keybindings

  cursor_shape: {
    vi_insert: underscore
    vi_normal: block
    emacs: block
  }

  use_kitty_protocol: true
}

# set NU_OVERLAYS with overlay list, useful for starship prompt
$env.config.hooks.pre_prompt = ($env.config.hooks.pre_prompt | append {||
  let overlays = overlay list | slice 1..
  if not ($overlays | is-empty) {
    $env.NU_OVERLAYS = $overlays | str join ", "
  } else {
    $env.NU_OVERLAYS = null
  }
})

use "~/.config/nushell/path.nu" *
use "~/.config/nushell/local.nu" *
use "~/.config/nushell/jj.nu" *
use "~/.config/nushell/prompt.nu" *
use "~/.config/nushell/alias.nu" *
use "~/.config/nushell/functions.nu" *

source "~/.config/nushell/zoxide.nu"
source "~/.config/nushell/carapace.nu"

# $env.LS_COLORS = (vivid generate one-dark)

