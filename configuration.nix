{ config, pkgs, inputs, ... }:

{
  # Imports
  imports = [ ./cachix.nix ];

  # Boot Configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "kvm.enable_virt_at_load=0" ];

    # LUKS Encryption - CRITICAL: DO NOT REMOVE
    initrd.luks.devices."luks-36c05312-8950-44c2-9f98-a1881126b00e".device = "/dev/disk/by-uuid/36c05312-8950-44c2-9f98-a1881126b00e";

    # AppImage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
  };

  # Networking
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    hosts = { "10.1.1.140" = [ "gitlab.alab.local" ]; };
    firewall.checkReversePath = "loose";
  };

  # Localization
  time.timeZone = "Europe/Warsaw";
  console.keyMap = "pl2";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pl_PL.UTF-8";
      LC_IDENTIFICATION = "pl_PL.UTF-8";
      LC_MEASUREMENT = "pl_PL.UTF-8";
      LC_MONETARY = "pl_PL.UTF-8";
      LC_NAME = "pl_PL.UTF-8";
      LC_NUMERIC = "pl_PL.UTF-8";
      LC_PAPER = "pl_PL.UTF-8";
      LC_TELEPHONE = "pl_PL.UTF-8";
      LC_TIME = "pl_PL.UTF-8";
    };
  };

  # Desktop Environment
  # X11 & Gnome/COSMIC
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "pl";
        variant = "";
      };
    };
    # Gnome Desktop
    displayManager.gdm.enable = true;
    desktopManager.gnome = {
      enable = true;
      sessionPath = [ pkgs.gedit pkgs.mutter ];
    };
    # COSMIC Desktop
    # desktopManager.cosmic.enable = true;
    # displayManager.cosmic-greeter.enable = true;
  };

  # Enable GNOME Extensions installed in home.nix
  services.gnome.gnome-browser-connector.enable = true;

  # COSMIC keyboard workaround
  systemd.tmpfiles.rules = [
    "L /usr/share/X11/xkb/rules/base.xml - - - - ${pkgs.xkeyboard_config}/share/X11/xkb/rules/base.xml"
  ];

  # Input configuration
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main = {
        leftalt = "layer(control)";
        leftcontrol = "layer(alt)";
      };
    };
  };

  # Libinput Quirk for palm rejection w/ Keyd
  # https://github.com/rvaiya/keyd/issues/723
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
  };

  # Core services
  services = {
    printing.enable = true;
    flatpak.enable = true;
    tailscale.enable = true;
    fwupd.enable = true;
    bpftune.enable = true;
    usbmuxd.enable = true;
    fail2ban.enable = true;

    # Logitech device support
    solaar = {
      enable = true;
      package = pkgs.solaar;
      window = "hide";
      batteryIcons = "regular";
      extraArgs = "";
    };

    # SSH server config
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };

  # Virtualization
  virtualisation = {
    docker.enable = true;
    # virtualbox = {
    #   host = {
    #     enable = true;
    #     enableExtensionPack = true;
    #   };
    #   guest = {
    #     enable = true;
    #     dragAndDrop = true;
    #   };
    # };
  };

  # User configuration
  users.users.benji = {
    isNormalUser = true;
    description = "Benji";
    extraGroups = [ "networkmanager" "wheel" "dialout" "docker" "vboxusers" ];
    shell = pkgs.fish;
  };

  # Nix package manager configuration
  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      # Warning: max-jobs is automatically set by the system based on available cores
      # Setting this manually is discouraged unless you have a specific reason
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System Packages
  environment.systemPackages = with pkgs; [
    # Terminal utilities
    ghostty
    wget
    curl
    git
    htop
    unzip
    busybox
    openssl
    imagemagick

    # System tools
    usbutils
    appimage-run
    topgrade
    tailscale
    atuin
    distrobox
    wireguard-tools

    # Development
    esptool
    android-tools

    # Custom packages
    pixelflasher
    libimobiledevice
    bpftune
    unrar

    # Wine
    wineWowPackages.stable # support both 32-bit and 64-bit applications
    winetricks # winetricks (all versions)
    wineWowPackages.waylandFull # native wayland support (unstable)
  ];

  # Shell configuration
  programs.fish.enable = true;

  # Font configuration
  fonts.packages = with pkgs; [
    # Sans-serif fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf

    # Monospace fonts
    fira-code
    fira-code-symbols
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono

    # Additional fonts
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    corefonts
    vistafonts
  ];

  # Security
  security = {
    apparmor = {
      enable = true;
      packages = [ pkgs.apparmor-profiles ];
    };
    auditd.enable = true;
  };

  # Do not modify - will cause rebuild
  system.stateVersion = "23.11";
}
