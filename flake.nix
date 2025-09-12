{
  description = "NixOS configuration with flakes";

  inputs = {
    # Core inputs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Device support
    # https://github.com/Svenum/Solaar-Flake
    solaar = {
      url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixos-hardware,
    home-manager,
    solaar,
    ...
  }:
  let
    system = "x86_64-linux";

    # Create optimized package set
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    # Custom overlay for local packages
    overlays = [
      (final: prev: {
        pixelflasher = final.callPackage ./pixelflasher.nix { };
        # Pin Google Chrome to version 139
        google-chrome = prev.google-chrome.overrideAttrs (oldAttrs: rec {
          version = "139.0.7258.154";
          src = prev.fetchurl {
            url = "https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${version}-1_amd64.deb";
            hash = "sha256-6uEk4a5bVlsVNwW+ZHHBgTGmw/ArgrRQwKfLcSITt8o=";
          };
        });
      })
    ];
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        # Hardware configuration
        nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
        ./hardware-configuration.nix

        # Base system configuration
        ./configuration.nix

        # Home-manager configuration
        home-manager.nixosModules.home-manager
        {
          nixpkgs.overlays = overlays;
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.benji = import ./home.nix;
            backupFileExtension = "backup";
            extraSpecialArgs = { inherit inputs; };
          };
        }

        # Additional modules
        solaar.nixosModules.default
      ];
    };
  };
}
