{
  description = "Jimmie's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    archetect-tap = {
      url = "github:archetect/homebrew-tap";
      flake = false;
    };
    nikitabobko-tap = {
        url = "github:nikitabobko/homebrew-tap";
        flake = false;
    };
    p6m-tap = {
      url = "github:p6m-dev/homebrew-tap";
      flake = false;
    };
  };

  outputs = inputs@{ self, darwin, nixpkgs, home-manager, nix-homebrew, homebrew-core, homebrew-cask, archetect-tap, nikitabobko-tap, p6m-tap }:
  let
    # Common configuration shared across all hosts
    mkDarwinSystem = hostConfig: darwin.lib.darwinSystem {
      modules = [
        hostConfig
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.jimmie = import ./modules/home.nix;
        }
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = false;
            user = "jimmie";
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "archetect/archetect-tap" = archetect-tap;
              "nikitabobko/homebrew-tap" = nikitabobko-tap;
              "p6m-dev/homebrew-tap" = p6m-tap;
            };
            autoMigrate = true;
          };
        }
      ];
      specialArgs = { inherit inputs; };
    };
  in
  {
    darwinConfigurations = {
      "Jimmie-Macbook16" = mkDarwinSystem ./hosts/macbook16.nix;
      "Jimmie-Macbook14-M3" = mkDarwinSystem ./hosts/macbook14.nix;
      "Jimmie-Mac-Studio" = mkDarwinSystem ./hosts/mac-studio.nix;
    };
  };

}
