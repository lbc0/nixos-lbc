{ pkgs, ... }:
{
  home.packages = with pkgs; [
    brave
    alacritty
    fuzzel
    swaybg
    swaylock
  ];
}
