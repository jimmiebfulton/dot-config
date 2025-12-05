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

    settings = {
      user = {
        name = "Jimmie Fulton";
        email = "jimmie.fulton@gmail.com";
      };
      credential = {
        helper = "osxkeychain";
      };
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

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
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
    '';
  };

  programs.bash = {
    enable = true;
    bashrcExtra = ''
# Ensure nix-installed tools are available in bash
export EDITOR=nvim
export XDG_CONFIG_HOME="/Users/jimmie/.config"
export JJ_CONFIG="/Users/jimmie/.config/jj/config.toml"
export PNPM_HOME="/Users/jimmie/bin"
    '';
  };

  programs.nushell = {
    enable = true;
    # Load the local.nu file which contains sensitive environment variables
    extraConfig = ''
      # Source local configuration if it exists
      if ($"($env.HOME)/.config/nushell/local.nu" | path exists) {
        source ~/.config/nushell/local.nu
      }
    '';
  };

  # Set environment variables for all shells
  home.sessionVariables = {
    EDITOR = "nvim";
    XDG_CONFIG_HOME = "/Users/jimmie/.config";
    JJ_CONFIG = "/Users/jimmie/.config/jj/config.toml";
    PNPM_HOME = "/Users/jimmie/bin";
  };

  # Add paths for all shells
  home.sessionPath = [
    "$HOME/.npm-global/bin"
    "$HOME/.cargo/bin"
    "$HOME/bin"
  ];

  # Additional home configurations go here
}
