{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable LUKS
  boot.initrd.luks.devices."luks-36c05312-8950-44c2-9f98-a1881126b00e".device = "/dev/disk/by-uuid/36c05312-8950-44c2-9f98-a1881126b00e";

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  
  # Use networking.hosts instead of networking.extraHosts
  networking.hosts = {
    "10.1.1.140" = [ "gitlab.alab.local" ];
  };

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

  # Enable X11 and COSMIC
  services = {
    xserver = {
      enable = true;
      # Start Gnome
      displayManager.gdm.enable = true;
      desktopManager.gnome = {
        enable = true;
        sessionPath = [ pkgs.gedit pkgs.mutter ];
      };
      # End Gnome
      xkb = {
        layout = "pl";
        variant = "";
      };
    };
    # Start COSMIC
    # desktopManager.cosmic.enable = true;
    # displayManager.cosmic-greeter.enable = true;
    # End COSMIC
  };

  # COSMIC keyboard workaround - TEMPORARY
  systemd.tmpfiles.rules = [
    "L /usr/share/X11/xkb/rules/base.xml - - - - ${pkgs.xkeyboard_config}/share/X11/xkb/rules/base.xml"
  ];

  console.keyMap = "pl2";

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
  # Optional, but makes sure that when you type the make palm rejection work with keyd
  # https://github.com/rvaiya/keyd/issues/723
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';

  # Enable various services
  services.printing.enable = true;
  services.flatpak.enable = true;
  services.tailscale.enable = true;
  services.fwupd.enable = true;
  services.bpftune.enable = true;

  # Enable sound with pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Define user account
  users.users.benji = {
    isNormalUser = true;
    description = "Benji";
    extraGroups = [ "networkmanager" "wheel" "dialout" "docker" ];
    shell = pkgs.fish;
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  # Nix settings
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    wget
    curl
    usbutils
    git
    htop
    unzip
    busybox
    esptool
    bottles
    appimage-run
    topgrade
    tailscale
    atuin
    android-tools
    openssl
    imagemagick
    bpftune
    pixelflasher
  ];

  # Enable programs
  programs = {
    fish.enable = true;
  };

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

  # AppImage support
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  # Security enhancements
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
