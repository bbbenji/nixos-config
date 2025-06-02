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
    cachix

    # Development
    code-cursor # Main editor
    yarn
    deno
    direnv
    nodejs
    docker-compose
    glab
    awscli2

    # Python development
    (python311.withPackages (ps: with ps; [
      pip
      virtualenv
      black
      flake8
      mypy
      pytest
      ipython
      # jupyter
      pandas
      numpy
      requests
    ]))

    # Python tools (would normally be in pipx)
    pipenv

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

      # Python settings
      set -gx PYTHONDONTWRITEBYTECODE 1  # Prevent Python from writing .pyc files
      set -gx VIRTUAL_ENV_DISABLE_PROMPT 1  # Let fish handle the prompt modification
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

      # Python shortcuts
      py = "python";
      venv = "python -m venv .venv && source .venv/bin/activate.fish";
      pvenv = "python -m virtualenv .venv && source .venv/bin/activate.fish";
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
        ms-python.vscode-pylance
        golang.go
        vue.volar

        # Web development
        bradlc.vscode-tailwindcss
        esbenp.prettier-vscode

        # DevOps
        ms-azuretools.vscode-docker
        github.vscode-github-actions
        ms-vscode-remote.remote-containers

        # Utilities
        eamodio.gitlens
        jock.svg
        mechatroner.rainbow-csv

        # Nix specific
        arrterian.nix-env-selector
        mkhl.direnv
      ];

      userSettings = {
        # Editor appearance
        "editor.fontFamily" = "'FiraCode Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 14;
        "editor.lineHeight" = 22;
        "editor.minimap.enabled" = true;
        "editor.minimap.renderCharacters" = true;
        "editor.minimap.maxColumn" = 120;
        "editor.minimap.showSlider" = "always";

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
        "editor.defaultFormatter" = "esbenp.prettier-vscode";

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

  # Python development environment - managed through packages
  # Note: Using system packages instead of home-manager's programs.python
  # as it's not available in the current home-manager version
}
