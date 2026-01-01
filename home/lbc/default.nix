{ config, ... }:
{
  imports = [
    ./shell.nix
    ./apps.nix
    ./dev.nix
  ];

  home.username = "lbc";
  home.homeDirectory = "/home/lbc";
  home.stateVersion = "25.11";

  programs.git.enable = true;

  xdg.configFile = {
    niri = {
      source = config.lib.file.mkOutOfStoreSymlink
        "${config.home.homeDirectory}/nixos-lbc/dotfiles/config/niri";
      recursive = true;
    };
  };
}
