{ config, lib, pkgs, host, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  # networking.hostName = "lbc";
  networking.networkmanager.enable = true;

  # Bluetooth & power
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Time
  time.timeZone = "Africa/Casablanca";

  # Display manager
  services.displayManager.ly.enable = true;
#  services.greetd = {
#    enable = true;
#
#    settings = {
#      default_session = {
#        user = "greeter";
#        command = ''
#          ${pkgs.greetd.tuigreet}/bin/tuigreet \
#            --cmd niri \
#            --remember \
#            --time
#        '';
#      };
#    };
#  };

  # Niri
  programs.niri.enable = true;

  # User
  users.users.lbc = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # System-wide packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    gnome-keyring
    brightnessctl
    wl-clipboard
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # NixOS versioning
  system.stateVersion = "25.11";
}
