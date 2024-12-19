# nixos-config

This repository holds a flake-based NixOS configuration for easy reproducibility and maintenance.

## Structure

- **flake.nix**: Defines system inputs and main configuration.
- **configuration.nix**: System-level settings (services, networking, locales, etc.).
- **hardware-configuration.nix**: Auto-generated hardware config.
- **home.nix**: Per-user configuration managed by home-manager.
- **pixelflasher.nix**: Custom derivation for PixelFlasher.
- **README.md**: Documentation and instructions.

## Install

By default, NixOS places the configuration in /etc/nixos, which requires root permissions for modification, making it inconvenient for daily use. However, you can place your flake in ~/nixos-config and create a symbolic link in /etc/nixos as follows:

```shell
cd ~/
git clone git@github.com:bbbenji/nixos-config.git
sudo mv /etc/nixos /etc/nixos.bak  # Backup the original configuration
sudo ln -s ~/nixos-config/ /etc/nixos

# Deploy the flake.nix located at the default location (/etc/nixos)
sudo nixos-rebuild switch
```

# Update

```shell
update = "nix flake update";
upgrade = "sudo nixos-rebuild switch --flake .# && topgrade --disable containers";
cleanup = "sudo nix-collect-garbage --delete-older-than 7d && nix-collect-garbage --delete-older-than 7d";
```
