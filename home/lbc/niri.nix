{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    fuzzel
    alacritty
    swaybg
    swaylock
    brave
  ];
}
