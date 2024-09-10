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
  
  networking.extraHosts = ''
    10.1.1.140 gitlab.alab.local
  '';

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

  # Enable X11 and GNOME
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome = {
      enable = true;
      sessionPath = [ pkgs.gedit pkgs.mutter ];
    };
    xkb = {
      layout = "pl";
      variant = "";
    };
  };

  console.keyMap = "pl2";

  # Enable various services
  services.printing.enable = true;
  services.flatpak.enable = true;
  services.tailscale.enable = true;
  services.fwupd.enable = true;

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
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  # Nix settings
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
  ];

  # Enable programs
  programs = {
    calls.enable = true;
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
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

  # Firewall settings
  networking.firewall.checkReversePath = "loose";

  system.stateVersion = "23.11";
}