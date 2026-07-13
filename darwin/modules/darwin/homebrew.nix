{ config, pkgs, ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;  # don't run `brew update` (taps are managed by nix-homebrew)
      upgrade = false;     # don't mass-upgrade casks on every rebuild (each cask
                           # upgrade prompts for sudo; run `brew upgrade` manually)
      cleanup = "zap";     # remove unlisted packages
      # Homebrew 6.0 refuses to load formulae from untrusted third-party
      # taps (archetect, atlassian/acli, nikitabobko, p6m-dev), which aborts
      # `brew bundle` during activation. Activation runs under sudo and can't
      # `brew trust` interactively, so opt out declaratively.
      extraEnv = {
        HOMEBREW_NO_REQUIRE_TAP_TRUST = "1";
        # Skip Homebrew's automatic post-install `brew cleanup`, which can
        # self-deadlock during activation (it tries to autoremove a still-locked
        # dependency, e.g. libffi, and reports the upgrade as failed). Unlisted
        # packages are still reconciled by onActivation.cleanup = "zap".
        HOMEBREW_NO_INSTALL_CLEANUP = "1";
      };
    };
    
    taps = [
      "homebrew/core"
      "homebrew/cask"
      "archetect/tap"
      "atlassian/acli"
      "nikitabobko/tap"
      "p6m-dev/tap"
    ];

    brews = [
      "acli"
      "archetect"
      "node"
      "xcodegen"
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
