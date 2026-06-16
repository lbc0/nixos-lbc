{
  pkgs,
  lib,
  ...
}: {
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Enable KVM kernel modules
  boot.kernelModules = ["kvm-intel"];

  # Enable libvirt + QEMU
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true; # optional: for TPM support (Windows 11)
    };
  };

  # Networking
  # networking.hostName = "lbc";
  networking = {
    networkmanager.enable = true;
    firewall = {
      allowedUDPPorts = [67 68 53 53317];
      allowedTCPPorts = [8000 53317];
    };
  };

  # ModemManager
  systemd.services.ModemManager = {
    enable = true;
    wantedBy = ["multi-user.target"];
  };

  # Bluetooth & power
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Display manager
  services.displayManager.ly.enable = true;

  # Gnome Keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.ly.enableGnomeKeyring = true;

  # DBuS
  services.dbus.enable = true;
  #services.dbus.packages = [ pkgs.gnome-keyring ];

  # sudo timeout
  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=0
  '';

  # Time
  time.timeZone = "Africa/Casablanca";

  # Niri
  programs.niri.enable = true;

  # Enable virt-manager (GUI)
  programs.virt-manager.enable = true;

  # Thunar File Manager
  programs.thunar.enable = true;

  programs.xfconf.enable = true; # For thunar preference changes

  # GNOME Virtual Filesystem
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  # Thunar plugins
  programs.thunar.plugins = with pkgs; [
    xfce.thunar-archive-plugin # Requires an Archive manager like file-roller, ark, etc
    xfce.thunar-volman
  ];

  # Optional: enable dconf (needed by virt-manager)
  programs.dconf.enable = true;

  # firefox
  programs.firefox.enable = true;

  # Optional but recommended: bridge networking helper
  virtualisation.spiceUSBRedirection.enable = true;

  # User
  users.users.lbc = {
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "kvm" "input"];
  };

  # System-wide packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    gnome-keyring
    libsecret
    brightnessctl
    wl-clipboard
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Nix settings
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # NixOS versioning
  system.stateVersion = "25.11";
}
