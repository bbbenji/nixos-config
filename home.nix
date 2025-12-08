{ config, pkgs, inputs, ... }:

{
  home = {
    username = "benji";
    homeDirectory = "/home/benji";

    # State version should match system's
    stateVersion = "23.11";

    # Development tooling
    sessionVariables = {
      EDITOR = "code --wait";
      VISUAL = "code --wait";
      BROWSER = "google-chrome";
    };
  };

  # User Packages
  home.packages = with pkgs; [
    # Web browsers
    firefox
    google-chrome

    # Communication & messaging
    beeper
    localsend
    calls
    signal-desktop

    # System utilities & tools
    modem-manager-gui
    gnome-tweaks
    yad
    openfortivpn
    cachix
    flameshot
    grim

    # Development tools
    vscode
    code-cursor
    yarn
    deno
    direnv
    nodejs
    docker-compose
    glab
    # awscli2
    python3

    # AI & productivity
    claude-code
    gemini-cli
    codex
    antigravity-fhs
    # obsidian
    # synology-drive-client

    # File management
    filezilla

    # Database tools
    sqlitebrowser

    # Media & entertainment
    spotify
    ledger-live-desktop

    # 3D printing & modeling
    openscad
    orca-slicer

    # Desktop themes
    whitesur-gtk-theme
    whitesur-icon-theme
    whitesur-cursors
    xorg.xcursorthemes

    # GNOME Shell extensions
    gnomeExtensions.solaar-extension
    gnomeExtensions.caffeine
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.just-perfection
    gnomeExtensions.notification-banner-reloaded
    gnomeExtensions.spotify-tray
    gnomeExtensions.tailscale-qs
    gnomeExtensions.wiggle
    gnomeExtensions.vicinae
    # Note: draw-on-your-screen2 not available in nixpkgs
  ];

  # Git configuration
  programs.git = {
    enable = true;

    # Useful Git aliases
    settings = {
      user.name = "Benji";
      # user.email = "your.email@example.com"; # Replace if needed
      core = {
        editor = "code --wait";
        autocrlf = "input";
      };
      pull.rebase = true;
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      fetch.prune = true;
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
      upnix = "update && upgrade && cleanup";
      update = "pushd ~/nixos-config && nix flake update && popd";
      upgrade = "pushd ~/nixos-config && sudo nixos-rebuild switch --flake .# && topgrade --disable containers && popd";
      cleanup = "pushd ~/nixos-config && sudo nix-collect-garbage --delete-older-than 14d && nix-collect-garbage --delete-older-than 14d && popd";
      upfw = "fwupdmgr refresh --force && fwupdmgr get-updates && fwupdmgr update";

      # Common shortcuts
      ll = "ls -la";
      la = "ls -a";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
    };

    functions = {
      # Create and cd to a directory in one command
      mkcd = "mkdir -p $argv[1]; and cd $argv[1]";
    };
  };

  # Editor configuration (Cursor - built on VSCode)
  programs.vscode = {
    enable = true;
    # package = pkgs.code-cursor;  # Use Cursor instead of VSCode
    package = pkgs.vscode;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # Language support
        bbenoist.nix
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

      # userSettings = {
      #   # Editor appearance
      #   "editor.fontFamily" = "'FiraCode Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
      #   "editor.fontLigatures" = true;
      #   "editor.fontSize" = 14;
      #   "editor.lineHeight" = 22;
      #   "editor.minimap.enabled" = true;
      #   "editor.minimap.renderCharacters" = true;
      #   "editor.minimap.maxColumn" = 120;
      #   "editor.minimap.showSlider" = "always";

      #   # Editor behavior
      #   "editor.formatOnSave" = true;
      #   "editor.tabSize" = 2;
      #   "editor.insertSpaces" = true;

      #   # Workbench settings
      #   "workbench.startupEditor" = "none";
      #   "workbench.colorTheme" = "Default Dark+";

      #   # Terminal settings
      #   "terminal.integrated.fontFamily" = "'FiraCode Nerd Font'";
      #   "terminal.integrated.fontSize" = 14;

      #   # File handling
      #   "files.trimTrailingWhitespace" = true;
      #   "files.insertFinalNewline" = true;
      #   "files.autoSave" = "onFocusChange";
      #   "editor.defaultFormatter" = "esbenp.prettier-vscode";

      #   # Cursor AI settings
      #   "cursor.codebase.contextType" = "auto";
      # };
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

  # Vicinae service
  services.vicinae = {
    enable = true;
    autoStart = true;
  };
}
