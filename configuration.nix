{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Systemd-boot EFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # LUKS Encryption
  boot.initrd.luks.devices."luks-36c05312-8950-44c2-9f98-a1881126b00e".device = "/dev/disk/by-uuid/36c05312-8950-44c2-9f98-a1881126b00e";

  # Hostname & Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.hosts = {
    "10.1.1.140" = [ "gitlab.alab.local" ];
  };

  # Timezone & Locale
  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
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

  # X11 & Gnome/COSMIC
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "pl";
        variant = "";
      };
    };
    
    # Start Gnome
    xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome = {
        enable = true;
        sessionPath = [ pkgs.gedit pkgs.mutter ];
      };
    };
    # End Gnome

    # Start COSMIC
    # desktopManager.cosmic.enable = true;
    # displayManager.cosmic-greeter.enable = true;
    # End COSMIC

  };

  # COSMIC keyboard workaround
  systemd.tmpfiles.rules = [
    "L /usr/share/X11/xkb/rules/base.xml - - - - ${pkgs.xkeyboard_config}/share/X11/xkb/rules/base.xml"
  ];

  console.keyMap = "pl2";

  # Keyd for custom keyboard layers
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            leftalt = "layer(control)";
            leftcontrol = "layer(alt)";
          };
        };
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

  # Common Services
  services.printing.enable = true;
  services.flatpak.enable = true;
  services.tailscale.enable = true;
  services.fwupd.enable = true;
  services.bpftune.enable = true;      # For network optimization
  services.usbmuxd.enable = true;      # iOS device support

  # Audio with PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # User account
  users.users.benji = {
    isNormalUser = true;
    description = "Benji";
    extraGroups = [ "networkmanager" "wheel" "dialout" "docker" ];
    shell = pkgs.fish;
  };

  # Docker
  virtualisation.docker.enable = true;

  # Nix configuration (allowUnfree already set in flake.nix)
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System Packages
  environment.systemPackages = with pkgs; [
    ghostty
    wget
    curl
    usbutils
    git
    htop
    unzip
    busybox
    esptool
    # bottles
    appimage-run
    topgrade
    tailscale
    atuin
    android-tools
    openssl
    imagemagick
    bpftune
    pixelflasher
    libimobiledevice
  ];

  # Fish Shell
  programs.fish.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    corefonts
    vistafonts
  ];

  # AppImage Support
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  # Security & SSH
  # networking.firewall = {
  #   enable = true;
  #   allowedTCPPorts = [ 80 443 ];  # Add specific ports as needed
  # };

  # system.autoUpgrade = {
  #   enable = true;
  #   allowReboot = false;
  # };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.fail2ban.enable = true;

  security.apparmor = {
    enable = true;
    packages = [ pkgs.apparmor-profiles ];
  };

  security.auditd.enable = true;
  networking.firewall.checkReversePath = "loose";

  system.stateVersion = "23.11";
}
