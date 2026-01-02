{ config, pkgs, lib, ... }:

{
  programs.niri = {
    package = pkgs.niri;  # Use the system-wide Niri package
    settings = {
      spawn-at-startup = [
        { command = [ "noctalia-shell" ]; }
      ];
    };
  };

  # User-specific Wayland packages (for this user only)
  home.packages = with pkgs; [
    fuzzel
    alacritty
    swaybg
    swaylock
    brave
  ];
}
