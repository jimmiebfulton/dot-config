{ config, pkgs, inputs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";

  # System configuration
  system = {
    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
      dock = {
        autohide = true;
        show-recents = false;
      };
      finder = {
        AppleShowAllExtensions = true;
        QuitMenuItem = true;
        FXEnableExtensionChangeWarning = false;
      };
    };
    stateVersion = 5;
  };

  # User configuration
  users.users.jimmie = {
    name = "jimmie";
    home = "/Users/jimmie";
  };

  # System packages
  environment.systemPackages = with pkgs; [
    bat
    carapace
    curl
    difftastic
    eza
    fd
    fzf
    git
    jujutsu
    kanata
    just
    lazygit
    lazyjj
    neofetch
    neovide
    neovim
    nushell
    ripgrep
    rustup
    starship
    wezterm
    yazi
    zoxide
  ];


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable Nix command and flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "jimmie" ];
  };
}
