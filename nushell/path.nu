
export-env {
  if ("/opt/homebrew/" | path exists) {
    $env.PATH = ($env.PATH | prepend '/opt/homebrew/bin/')
  }

  if ("/run/current-system/sw/bin" | path exists) {
    $env.PATH = ($env.PATH | prepend "/run/current-system/sw/bin")
  }

  if ("/nix/var/nix/profiles/default/bin" | path exists) {
    $env.PATH = ($env.PATH | prepend "/nix/var/nix/profiles/default/bin")
  }
  if ("/Users/jimmie/.nix-profile/bin" | path exists) {
    $env.PATH = ($env.PATH | prepend "/Users/jimmie/.nix-profile/bin")
  }

  if ("~/.cargo/bin" | path exists) {
    $env.PATH = ($env.PATH | prepend ~/.cargo/bin/)
  }

  if ("~/bin" | path exists) {
    $env.PATH = ($env.PATH | append ($env.HOME | path join 'bin'))
  }

  if ("/Applications/Araxis Merge.app" | path exists) {
    $env.PATH = ($env.PATH | append "/Applications/Araxis Merge.app/Contents/Utilities/")
  }

  if ("/opt/homebrew/opt/llvm" | path exists) {
    $env.PATH = ($env.PATH | append "/opt/homebrew/opt/llvm/bin/")
  }

  if ("/usr/local/go/bin" | path exists) {
    $env.PATH = ($env.PATH | append "/usr/local/go/bin")
  }

  if ("~/go" | path exists) {
    $env.PATH = ($env.PATH | append "~/go/bin/")
  }

  if ("~/.local/bin" | path exists) {
    $env.PATH = ($env.PATH | append "~/.local/bin/")
  }

  if ("~/.rd/" | path exists) {
      $env.PATH = ($env.PATH | append "~/.rd/bin")
  }
}

