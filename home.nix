{ config, pkgs, ... }:

{
  home.username = "benji";
  home.homeDirectory = "/home/benji";

  home.packages = with pkgs; [
    firefox
    google-chrome
    beeper
    appimage-run
    topgrade
    tailscale
    localsend
    calls
    modem-manager-gui
    spotify
    fish
    albert
    signal-desktop
    whitesur-gtk-theme
    whitesur-icon-theme
    whitesur-cursors
    gnome-tweaks
    vscode
    filezilla
    atuin
    android-tools
    sqlitebrowser
    busybox
    esptool
  ];

  # programs.git = {
  #   enable = true;
  #   userName = "Benji";
  #   userEmail = "your.email@example.com";  # Replace with your email
  # };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      ms-python.python
      ms-azuretools.vscode-docker
    ];
  };

  # Gnome settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "WhiteSur-dark";
      icon-theme = "WhiteSur-dark";
      cursor-theme = "WhiteSur-cursors";
    };
  };

  home.stateVersion = "23.11";
}
