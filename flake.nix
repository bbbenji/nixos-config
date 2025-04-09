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

    # Desktop environment
    # https://github.com/lilyinstarlight/nixos-cosmic
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Device support
    # https://github.com/Svenum/Solaar-Flake
    solaar = {
      url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, nixos-hardware, home-manager, nixos-cosmic, solaar, ... }:
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

          # Cachix binaries
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }

          # Additional modules
          nixos-cosmic.nixosModules.default
          solaar.nixosModules.default
        ];
      };
    };
}
