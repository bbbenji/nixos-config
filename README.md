# NixOS Configuration

This repository contains my personal NixOS configuration using the Nix Flakes system for reproducible builds and easy maintenance. It's designed for a Lenovo ThinkPad X1 (9th gen) with a focus on development workflows and a clean GNOME desktop experience.

## Features

- **Declarative Configuration**: Complete system defined in code using the Nix language
- **Reproducibility**: Flake-based setup ensures consistent builds across machines
- **Home Manager Integration**: User-level configuration with dotfiles management
- **Custom Packages**: Includes custom derivations like PixelFlasher
- **Development Focus**: Configured for software development with Cursor (VSCode-based editor)
- **GNOME Desktop**: Enhanced with carefully selected extensions
- **Hardware Optimization**: Tuned specifically for ThinkPad X1 9th generation

## Repository Structure

- `flake.nix`: Entry point with inputs, outputs, and overlays
- `configuration.nix`: System-wide configuration (hardware, services, security)
- `home.nix`: User-specific configuration (applications, dotfiles, themes)
- `hardware-configuration.nix`: Auto-generated hardware settings (don't edit)
- `pixelflasher.nix`: Custom package definition

## Installation

For a fresh installation, clone this repository and create a symbolic link to make daily management easier:

```shell
# Clone the repository
cd ~/
git clone https://github.com/bbbenji/nixos-config.git

# Backup original configuration and create symbolic link
sudo mv /etc/nixos /etc/nixos.bak
sudo ln -s ~/nixos-config/ /etc/nixos

# Deploy the system
sudo nixos-rebuild switch --flake .#
```

## System Management

### Key Commands

| Command                                       | Description                             |
| --------------------------------------------- | --------------------------------------- |
| `sudo nixos-rebuild switch --flake .#`        | Apply system changes                    |
| `nixos-rebuild build --flake .#`              | Test build without applying             |
| `nix flake update`                            | Update flake inputs                     |
| `nix-collect-garbage --delete-older-than 14d` | Clean up old generations                |
| `topgrade --disable containers`               | Update system packages and applications |

### Fish Shell Aliases

The configuration includes useful Fish shell aliases:

- `update`: Update flake inputs
- `upgrade`: Rebuild NixOS and run topgrade
- `cleanup`: Run garbage collection for both system and user
- `mkcd`: Create directory and change to it in one command

## Development Environment

### Editor Setup

The system uses Cursor (VSCode-based) as the primary editor:

- Default editor system-wide (EDITOR/VISUAL environment variables)
- FiraCode Nerd Font with ligatures
- Configured for 2-space indentation
- Includes extensions for:
  - Language support (Nix, Python, Go, Vue, etc.)
  - Web development (Tailwind CSS, Prettier)
  - DevOps tools (Docker, GitHub Actions)
  - Utilities (GitLens, SVG, Data Preview)

### Development Tools

- Node.js and Yarn for JavaScript/TypeScript
- Python with VSCode integration
- Docker and Docker Compose
- Git with advanced configuration
- direnv for per-directory environment variables

## Desktop Customization

- GNOME desktop with custom theme (WhiteSur - macOS inspired)
- Essential GNOME extensions:
  - Dash to Dock
  - Clipboard Indicator
  - Caffeine (prevent sleep)
  - Notification Banner Reloaded
  - Spotify Tray
  - Tailscale Quick Settings

## Performance Optimizations

- Nix store optimization enabled
- Automatic garbage collection
- Efficient package grouping
- Use of specialArgs to pass flake inputs

## Security Note

The system uses LUKS encryption. Do not remove the LUKS configuration in `boot.initrd.luks.devices`.

## Code Style Conventions

- 2-space indentation for all Nix files
- Group related settings with clear section comments
- Import order: hardware modules first, then system, then home-manager
- Categorize packages by function (browsers, development, etc.)
- Use attribute sets for related options
- Prefer declarative home-manager configs over manual customization

## License

This project is licensed under MIT - see the LICENSE file for details.
