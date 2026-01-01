{ pkgs, ... }:
{
  programs.niri.enable = true;

  services.seatd.enable = true;
  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    xdg-utils
  ];
}
