{pkgs, ...}: {
  # ── Bootloader ───────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = ["kvm-intel" "i2c-dev"];

  # ── Virtualisation (KVM / QEMU / virt-manager) ───────────────────────────
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true; # TPM support (needed for Windows 11 guests)
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;
  programs.dconf.enable = true; # required by virt-manager

  # ── Networking ───────────────────────────────────────────────────────────
  networking = {
    networkmanager.enable = true;
    firewall = {
      # 67/68: DHCP (hotspot), 53: DNS, 53317: LocalSend
      allowedUDPPorts = [67 68 53 53317];
      # 8000: python http.server (file sharing), 53317: LocalSend
      allowedTCPPorts = [8000 53317];
    };
  };

  # ModemManager: needed for mobile broadband / SIM management
  systemd.services.ModemManager = {
    enable = true;
    wantedBy = ["multi-user.target"];
  };

  # ── Hardware ─────────────────────────────────────────────────────────────
  hardware.bluetooth.enable = true;
  hardware.i2c.enable = true; # DDC/CI
  services.blueman.enable = true; # Bluetooth GUI
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # ── Display / Session ────────────────────────────────────────────────────
  services.displayManager.ly.enable = true; # TUI login manager
  programs.niri.enable = true; # Wayland compositor
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
  #     };
  #   };
  # };

  # ── Security ─────────────────────────────────────────────────────────────
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.ly.enableGnomeKeyring = true;
  # Ask for sudo password every time (no caching)
  security.sudo.extraConfig = "Defaults timestamp_timeout=0";

  # ── DBus ─────────────────────────────────────────────────────────────────
  services.dbus.enable = true;

  # ── Time ─────────────────────────────────────────────────────────────────
  time.timeZone = "Africa/Casablanca";
  services.chrony = {
    enable = true;
    servers = [
      "0.pool.ntp.org"
      "1.pool.ntp.org"
      "2.pool.ntp.org"
      "3.pool.ntp.org"
      "time.cloudflare.com"
      "time.google.com"
    ];
  };

  # ── File Manager (Thunar) ────────────────────────────────────────────────
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin # right-click → extract/compress
      thunar-volman # auto-mount removable drives
    ];
  };
  programs.xfconf.enable = true; # persists Thunar preferences
  services.gvfs.enable = true; # trash, network mounts, MTP
  services.tumbler.enable = true; # image thumbnails

  # ── Browser ──────────────────────────────────────────────────────────────
  programs.firefox.enable = true;

  # ── User ─────────────────────────────────────────────────────────────────
  users.users.lbc = {
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "kvm" "input" "i2c"];
  };

  # ── System Packages ──────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    gitsign
    gnome-keyring
    libsecret # for gnome-keyring CLI access
    brightnessctl # keyboard backlight / screen brightness
    ddcutil # monitors
    wl-clipboard # wl-copy / wl-paste
  ];

  # ── Global Editor ────────────────────────────────────────────────────────
  environment.variables.EDITOR = "nvim";

  # ── Fonts ────────────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # ── Nix ──────────────────────────────────────────────────────────────────
  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "26.05";
}
