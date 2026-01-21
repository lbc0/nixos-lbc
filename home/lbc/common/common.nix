{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-lbc/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Only relevant configs
  configs = {
    niri = "niri";
    quickshell = "quickshell";
  };
in

{
  imports = [
    ./nvf.nix
    ./packages.nix
  ];

  # Basic Home Manager setup
  home.username = "lbc";
  home.homeDirectory = "/home/lbc";
  home.stateVersion = "25.11";

  # Git + shell
  programs.git = {
    enable = true;
  
    settings.user = {
      name  = "lbc0";
      email = "lbouchouari0@gmail.com";
    };
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      export PS1="\[\e[38;5;75m\]\u@\h \[\e[38;5;113m\]\w \[\e[38;5;189m\]\$ \[\e[0m\]"
    '';
  };

  # Dotfiles symlinks
  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;
}

