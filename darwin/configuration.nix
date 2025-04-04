{ config, pkgs, inputs, ... }:

{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.enable = false;

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
        autohide-delay = 0.0;
        show-recents = false;
        orientation = "right";
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

  

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    _1password-cli
    aider-chat
    awscli
    bat
    carapace
    chatgpt
    claude-code
    curl
    difftastic
    eza
    fd
    firefox
    fzf
    git
    gh
    google-chrome
    grpcurl
    jujutsu
    jjui
    just
    k9s
    kanata
    kind
    kubectl
    kustomize
    lazygit
    lazyjj
    mas
    neofetch
    neovide
    neovim
    nodejs_23
    nushell
    obsidian
    pnpm
    postman
    ripgrep
    raycast
    rustup
    signal-desktop
    slack
    starship
    telegram-desktop
    tilt
    vivid
    wezterm
    yazi
    zoom-us
    zoxide
  ];

homebrew = {
      enable = true;

      casks = [
        "1password"
        "claude"
        "dropbox"
        "forklift"
        "jetbrains-toolbox"
        "keyboard-maestro"
        "microsoft-office"
        "microsoft-teams"
        "whatsapp"
        "parallels"
        "rancher"
      ];

      # TODO: Uncomment after mas is fixed
      # masApps = {
      #   "1Password for Safari" = 1569813296;
      #   "Final Cut Pro" = 424389933;
      #   "Facebook Messager" = 1480068668;
      #   "Monodraw" = 920404675;
      #   "Omnigraffle 7" = 1142578753;
      #   "PDF Expert" = 1055273043;
      #   "Pixelmator Pro" = 1289583905;
      #   "Photomator - Photo Editor" = 1444636541;
      #   "Things 3" = 904280696;
      #   "Xcode" = 497799835; 
      # };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable Nix command and flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "jimmie" ];
  };
}
