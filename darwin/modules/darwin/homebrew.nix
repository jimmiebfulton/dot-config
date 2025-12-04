{ config, pkgs, ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;  # don't run `brew update` (taps are managed by nix-homebrew)
      upgrade = true;      # run `brew upgrade` on darwin-rebuild
      cleanup = "zap";     # remove unlisted packages
    };
    
    taps = [
      "homebrew/core"
      "homebrew/cask"
      "archetect/tap"
      "nikitabobko/tap"
      "p6m-dev/tap"
    ];

    brews = [
      "archetect"
      "node"
      "p6m"
    ];

    casks = [
      "1password"
      "aerospace"
      "araxis-merge"
      "chatgpt"
      "claude"
      "dropbox"
      "firefox"
      "forklift"
      "google-chrome"
      "jetbrains-toolbox"
      "keyboard-maestro"
      "karabiner-elements"
      "microsoft-office"
      "microsoft-teams"
      "raycast"
      "whatsapp"
      "parallels"
      "rancher"
      "signal"
      "slack"
      "wezterm"
    ];

    # TODO: Uncomment after mas is fixed: https://github.com/mas-cli/mas/issues/724
    # masApps = {
    #  "1Password for Safari" = 1569813296;
    #  "Final Cut Pro" = 424389933;
    #  "Facebook Messager" = 1480068668;
    #  "Monodraw" = 920404675;
    #  "Omnigraffle 7" = 1142578753;
    #  "PDF Expert" = 1055273043;
    #  "Pixelmator Pro" = 1289583905;
    #  "Photomator - Photo Editor" = 1444636541;
    #  "Things 3" = 904280696;
    #  "Xcode" = 497799835; 
    #};
  };
}
