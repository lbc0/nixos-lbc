{ config, lib, pkgs, ... }:

{
  # imports only the hardware config
  imports = [
    ./hardware.nix
    ./sops.nix
    # ./noctalia.nix  # Noctalia system package
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos";
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
