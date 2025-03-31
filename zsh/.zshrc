# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# nix-darwin paths
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# Add nix-darwin managed Darwin executables
export PATH="$PATH:/run/current-system/sw/bin"

# Add any additional nix-darwin paths if needed
export PATH="$PATH:$HOME/.nix-profile/bin"

