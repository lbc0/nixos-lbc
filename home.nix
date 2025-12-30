{ config, pkgs, ... }:

{
  imports = [
    ./modules/neovim.nix
  ];

  home.username = "lbc";
  home.homeDirectory = "/home/lbc";
  programs.git.enable = true;
  home.stateVersion = "25.11";
  programs.bash = {
    enable = true;
    shellAliases = {
      nix-lbc = "Lbc's NixOS!";
    };
  };
  home.file.".config/qtile".source = ./config/qtile;
}
