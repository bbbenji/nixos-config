# nixos-config

By default, NixOS places the configuration in /etc/nixos, which requires root permissions for modification, making it inconvenient for daily use. However, you can place your flake in ~/nixos-config and create a symbolic link in /etc/nixos as follows:

```shell
mkdir ~/nixos-config
sudo mv /etc/nixos /etc/nixos.bak  # Backup the original configuration
sudo ln -s ~/nixos-config/ /etc/nixos

# Deploy the flake.nix located at the default location (/etc/nixos)
sudo nixos-rebuild switch
```
