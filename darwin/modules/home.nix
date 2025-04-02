{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "jimmie";
  home.homeDirectory = "/Users/jimmie";

  # This value determines the Home Manager release that your configuration is compatible with
  home.stateVersion = "23.11"; # Adjust this to match your chosen version

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Add your home-manager configurations here
  # For example:
  programs.git = {
    enable = true;
    userName = "Jimmie Fulton";
    userEmail = "jimmie.fulton@gmail.com"; # Replace with your actual email
  };

  programs.zsh = {
    enable = true;
    envExtra = ''
# Your .zshenv content goes here
export ZDOTDIR="$HOME/.config/zsh"
export EDITOR=nvim
export XDG_CONFIG_HOME="/Users/jimmie/.config"
export JJ_CONFIG="$HOME/.config/jj/config.toml"
    '';
  };

  # Additional home configurations go here
}
