{ config, pkgs, ... }:

{
  home.username = "benji";
  home.homeDirectory = "/home/benji";

  home.packages = with pkgs; [
    firefox
    google-chrome
    beeper
    localsend
    calls
    modem-manager-gui
    spotify
    albert
    signal-desktop
    gnome-tweaks
    filezilla
    sqlitebrowser
    vscode
    yarn
    # corepack
    direnv
    nodejs
    yad
    openfortivpn
    docker-compose
    whitesur-gtk-theme
    whitesur-icon-theme
    whitesur-cursors
  ];

  programs.git = {
    enable = true;
    userName = "Benji";
    # userEmail = "your.email@example.com";  # Replace with your email
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
      update = "sudo nixos-rebuild switch";
      upgrade = "sudo nixos-rebuild switch --upgrade";
    };
  };

  programs.vscode = {
    enable = true;
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

  home.stateVersion = "23.11";
}