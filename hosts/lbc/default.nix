{ config, lib, pkgs, ... }:

{
  # imports only the hardware config
  imports = [
    ./hardware.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Time
  time.timeZone = "Africa/Casablanca";

  # Display manager
  services.displayManager.ly.enable = true;

  # Wayland compositor
  programs.niri.enable = true;

  # User
  users.users.lbc = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # System-wide packages (minimal)
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

