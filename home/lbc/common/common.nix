{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-lbc/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Only relevant configs
  configs = {
    niri = "niri";
    quickshell = "quickshell";
    swayidle = "swayidle";
  };
in

{
  imports = [
    ./nvf.nix
    ./packages.nix
    ./mpv.nix
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
      export SOPS_AGE_KEY_FILE=/home/lbc/nixos-lbc/.ignore/.keys.txt
    '';
  };

  programs.neovim.defaultEditor = true;

  programs.onlyoffice = {
    enable = true;
  };

  # Dotfiles symlinks
  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;
}

