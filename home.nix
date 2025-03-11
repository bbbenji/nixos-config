{ config, pkgs, inputs, ... }:

{
  home = {
    username = "benji";
    homeDirectory = "/home/benji";

    # State version should match system's
    stateVersion = "23.11";

    # Development tooling
    sessionVariables = {
      EDITOR = "cursor --wait";
      VISUAL = "cursor --wait";
      BROWSER = "google-chrome";
    };
  };

  # Package categorization
  home.packages = with pkgs; [
    # Browsers
    firefox
    google-chrome

    # Communication
    beeper
    localsend
    calls
    signal-desktop

    # System utilities
    modem-manager-gui
    albert
    gnome-tweaks
    yad
    openfortivpn

    # Development
    code-cursor # Main editor
    yarn
    direnv
    nodejs
    docker-compose
    glab

    # File management
    filezilla

    # Databases
    sqlitebrowser

    # Media
    spotify

    # 3D Printing
    openscad
    orca-slicer

    # Themes and visuals
    whitesur-gtk-theme
    whitesur-icon-theme
    whitesur-cursors
    xorg.xcursorthemes

    # GNOME Extensions
    gnomeExtensions.solaar-extension
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dash-to-dock
    # Missing: draw-on-your-screen2 (not found in nixpkgs repository)
    gnomeExtensions.just-perfection
    gnomeExtensions.notification-banner-reloaded
    gnomeExtensions.spotify-tray
    gnomeExtensions.tailscale-qs
    gnomeExtensions.wiggle
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Benji";
    # userEmail = "your.email@example.com"; # Replace if needed

    extraConfig = {
      core = {
        editor = "cursor --wait";
        autocrlf = "input";
      };
      pull.rebase = true;
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      fetch.prune = true;
    };

    # Useful Git aliases
    aliases = {
      st = "status -sb";
      ci = "commit";
      co = "checkout";
      br = "branch";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
  };

  # Shell configuration
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      set -g fish_greeting

      # direnv is loaded automatically via home-manager

      # atuin is loaded automatically via home-manager
    '';

    shellAliases = {
      # System management
      update = "cd ~/nixos-config && nix flake update";
      upgrade = "cd ~/nixos-config && sudo nixos-rebuild switch --flake .# && topgrade --disable containers";
      cleanup = "cd ~/nixos-config && sudo nix-collect-garbage --delete-older-than 14d && nix-collect-garbage --delete-older-than 14d";

      # Common shortcuts
      ll = "ls -la";
      la = "ls -a";
      ".." = "cd ..";
      "..." = "cd ../..";
    };

    functions = {
      # Create and cd to a directory in one command
      mkcd = "mkdir -p $argv[1]; and cd $argv[1]";
    };
  };

  # Editor configuration (Cursor - built on VSCode)
  programs.vscode = {
    enable = true;
    package = pkgs.code-cursor;  # Use Cursor instead of VSCode

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Language support
        bbenoist.nix
        ms-python.python

        # DevOps
        ms-azuretools.vscode-docker

        # Utilities
        eamodio.gitlens
      ];

      userSettings = {
        # Editor appearance
        "editor.fontFamily" = "'FiraCode Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 14;
        "editor.lineHeight" = 22;

        # Editor behavior
        "editor.formatOnSave" = true;
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;

        # Workbench settings
        "workbench.startupEditor" = "none";
        "workbench.colorTheme" = "Default Dark+";

        # Terminal settings
        "terminal.integrated.fontFamily" = "'FiraCode Nerd Font'";
        "terminal.integrated.fontSize" = 14;

        # File handling
        "files.trimTrailingWhitespace" = true;
        "files.insertFinalNewline" = true;
        "files.autoSave" = "onFocusChange";

        # Cursor AI settings
        "cursor.codebase.contextType" = "auto";
      };
    };
  };

  # Terminal history
  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      filter_mode = "global";
    };
  };

  # Directory environment settings
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
