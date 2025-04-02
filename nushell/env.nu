# env.nu
#
# Installed by:
# version = "0.102.0"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

# if ('~/.cargo/bin/zoxide' | path exists) {
#   /opt/homebrew/bin/zoxide init nushell | save -f ~/.config/nushell/zoxide.nu
# } else {
#   echo "WARN: Zoxide is not installed"
# }
# 
# if ('/opt/homebrew/bin/carapace' | path exists) {
#   /opt/homebrew/bin/carapace _carapace nushell | save --force "~/.config/nushell/carapace.nu"
# }


/run/current-system/sw/bin/zoxide init nushell | save -f ~/.config/nushell/zoxide.nu
/run/current-system/sw/bin/carapace _carapace nushell | save --force "~/.config/nushell/carapace.nu"

