# nixos-config

## Install

By default, NixOS places the configuration in /etc/nixos, which requires root permissions for modification, making it inconvenient for daily use. However, you can place your flake in ~/nixos-config and create a symbolic link in /etc/nixos as follows:

```shell
mkdir ~/nixos-config
sudo mv /etc/nixos /etc/nixos.bak  # Backup the original configuration
sudo ln -s ~/nixos-config/ /etc/nixos

# Deploy the flake.nix located at the default location (/etc/nixos)
sudo nixos-rebuild switch
```

# Update

```shell
sudo nix-collect-garbage --delete-older-than 30d

sudo nix-channel --update && nix-channel --update
sudo nix flake update && nix flake update
topgrade --disable containers
# sudo nixos-rebuild boot --upgrade
# flatpak update -y
# fwupdmgr refresh --force && fwupdmgr get-updates && fwupdmgr update
```
