{ config, pkgs, ... }:

{
  home.username = "benji";
  home.homeDirectory = "/home/benji";

  home.packages = with pkgs; [
    firefox
    google-chrome
    brave
    beeper
    localsend
    calls
    modem-manager-gui
    spotify
    albert
    signal-desktop
    filezilla
    sqlitebrowser
    vscode
    code-cursor
    yarn
    direnv
    nodejs
    yad
    openfortivpn
    docker-compose
    whitesur-gtk-theme
    whitesur-icon-theme
    whitesur-cursors
    gnome-tweaks
    glab
    openscad
    orca-slicer
    xorg.xcursorthemes
    gnomeExtensions.solaar-extension
  ];

  programs.git = {
    enable = true;
    userName = "Benji";
    # userEmail = "your.email@example.com"; # Replace if needed
    extraConfig = {
      core.editor = "code --wait";
      pull.rebase = true;
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting
    '';
    shellAliases = {
      update = "cd ~/nixos-config && nix flake update";
      upgrade = "cd ~/nixos-config && sudo nixos-rebuild switch --flake .# && topgrade --disable containers";
      cleanup = "cd ~/nixos-config && sudo nix-collect-garbage --delete-older-than 7d && nix-collect-garbage --delete-older-than 7d";
    };
  };

  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        ms-python.python
        ms-azuretools.vscode-docker
      ];
      userSettings = {
        "editor.fontFamily" = "'FiraCode Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
        "editor.fontLigatures" = true;
      };
    };
  };

  home.stateVersion = "23.11";
}
