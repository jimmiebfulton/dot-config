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

      CustomUserPreferences = {
        "com.apple.finder" = {
          # ShowExternalHardDrivesOnDesktop = false;
          # ShowHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
          # _FXSortFoldersFirst = true;
          # FXDefaultSearchScope = "SCcf";
          FXICloudDriveEnabled = 1;
          FXICloudDriveDesktop = 1;
          FXICloudDriveDocuments = 1;
        };
        "com.apple.WindowManager" = {
          EnableStandardClickToShowDesktop = 0; # Click wallpaper to reveal desktop
          StandardHideDesktopIcons = 0; # Show items on desktop
          HideDesktop = 0; # Do not hide items on desktop & stage manager
          StageManagerHideWidgets = 0;
          StandardHideWidgets = 0;
        };
        "com.apple.screencapture" = {
          location = "~/Documents/Screenshots";
          type = "png";
        };
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
    cascadia-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    # Maple Mono (Ligature TTF unhinted)
    maple-mono.truetype
    # Maple Mono NF (Ligature unhinted)
    maple-mono.NF-unhinted
    # Maple Mono NF CN (Ligature unhinted)
    maple-mono.NF-CN-unhinted
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    _1password-cli
    aichat
    aider-chat
    awscli
    bat
    carapace
    claude-code
    curl
    delta
    difftastic
    eza
    fd
    firefox
    fzf
    git
    go
    gopls
    gh
    google-chrome
    google-cloud-sdk
    grpcurl
    jujutsu
    jjui
    just
    k9s
    kanata
    kind
    kubectl
    kubectx
    kustomize
    lazygit
    lazyjj
    lua
    luarocks
    markdownlint-cli2
    mas
    mdbook
    mdbook-toc
    mdbook-mermaid
    mdbook-admonish
    mdbook-pdf-outline
    mdbook-pagetoc
    mdbook-epub
    neofetch
    neovide
    neovim
    nodejs_23
    nushell
    obsidian
    pnpm
    postman
    python313
    python313Packages.pip
    ripgrep
    raycast
    rustup
    starship
    telegram-desktop
    tilt
    typst
    typstyle
    typstfmt
    uv
    vivid
    yazi
    zoom-us
    zoxide
  ];

homebrew = {
      enable = true;
      
      taps = [
        "archetect/tap"
      ];

      brews = [
        "archetect"
      ];

      casks = [
        "1password"
        "araxis-merge"
        "chatgpt"
        "claude"
        "dropbox"
        "forklift"
        "jetbrains-toolbox"
        "keyboard-maestro"
        "karabiner-elements"
        "microsoft-office"
        "microsoft-teams"
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable Nix command and flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "jimmie" ];
  };
}
