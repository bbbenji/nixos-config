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
    # flameshot
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
      update = "nix flake update";
      upgrade = "sudo nixos-rebuild switch --flake .# && topgrade --disable containers";
      cleanup = "sudo nix-collect-garbage --delete-older-than 7d && nix-collect-garbage --delete-older-than 7d";
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
