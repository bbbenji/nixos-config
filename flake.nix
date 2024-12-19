{
  description = "NixOS configuration with flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # https://github.com/lilyinstarlight/nixos-cosmic
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/ghostty-org/ghostty#nix-package
    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, nixos-cosmic, ghostty, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true; # Allow unfree packages globally
      };
      overlay = final: prev: {
        pixelflasher = final.callPackage ./pixelflasher.nix { };
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [ overlay ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.benji = import ./home.nix;
            home-manager.backupFileExtension = "backup";
          }
          # Nix substituters and trusted keys for COSMIC
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          # Ghostty integration
          {
            environment.systemPackages = [
              ghostty.packages.x86_64-linux.default
            ];
          }
          # NixOS Cosmic module
          nixos-cosmic.nixosModules.default
        ];
      };
    };
}
