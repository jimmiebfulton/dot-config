{ config, pkgs, inputs, ... }:

{
  # Import all darwin system modules
  imports = [
    ./packages.nix
    ./homebrew.nix
    ./fonts.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.enable = false;

  # System configuration
  system = {
    # Required for user-specific options (homebrew, system defaults, etc.)
    primaryUser = "jimmie";
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

      loginwindow = {
        GuestEnabled = false;
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

    # Keyboard configuration
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };

  # User configuration
  users.users.jimmie = {
    name = "jimmie";
    home = "/Users/jimmie";
    uid = 501;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable Nix command and flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "jimmie" ];
  };
}