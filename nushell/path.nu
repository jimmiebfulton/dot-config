
export-env {
  $env.PATH = ($env.PATH | prepend '/opt/homebrew/bin/')
  $env.PATH = ($env.PATH | prepend "/run/current-system/sw/bin")
  $env.PATH = ($env.PATH | prepend "/nix/var/nix/profiles/default/bin")
  $env.PATH = ($env.PATH | prepend ($env.HOME | path join ".nix-profile/bin"))
  $env.PATH = ($env.PATH | prepend ($env.HOME | path join ".cargo/bin"))
  $env.PATH = ($env.PATH | prepend "/usr/local/bin")
  $env.PATH = ($env.PATH | append ($env.HOME | path join 'bin'))
  $env.PATH = ($env.PATH | append ($env.HOME | path join 'go/bin'))
  $env.PATH = ($env.PATH | append ($env.HOME | path join '.local/bin'))
  $env.PATH = ($env.PATH | append ($env.HOME | path join '.rd/bin'))
  $env.PATH = ($env.PATH | append "/Applications/Araxis Merge.app/Contents/Utilities/")
  $env.PATH = ($env.PATH | append "/opt/homebrew/opt/llvm/bin/")
  $env.PATH = ($env.PATH | append "/usr/local/go/bin")
}

