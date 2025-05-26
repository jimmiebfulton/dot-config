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

    delta = {
      enable = true;
    };

    includes = [
      {
        path = "~/.config/git/work.inc";
        condition = "gitdir:~/work/";
      }
      {
        path = "~/.config/git/personal.inc";
        condition = "gitdir:~/personal/";
      }
    ];
  };

  # TODO: https://www.youtube.com/watch?v=XuQVbZ0wENE


  programs.zsh = {
    enable = true;
    envExtra = ''
# Your .zshenv content goes here
export ZDOTDIR="$HOME/.config/zsh"
export EDITOR=nvim
export XDG_CONFIG_HOME="/Users/jimmie/.config"
export JJ_CONFIG="/Users/jimmie/.config/jj/config.toml"
export PNPM_HOME="/Users/jimmie/bin"
export PATH="/Users/jimmie/.cargo/bin$PATH"
    '';
  };

  # Additional home configurations go here
}
