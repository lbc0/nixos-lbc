{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-lbc/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Only relevant configs
  configs = {
    nvim = "nvim";
    niri = "niri";
  };
in
{
  # Basic Home Manager setup
  home.username = "lbc";
  home.homeDirectory = "/home/lbc";
  home.stateVersion = "25.11";

  # Git + shell
  programs.git.enable = true;

  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake $HOME/nixos-lbc#lbc";
    };
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

  # User packages (Wayland-friendly)
  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    fuzzel    # Wayland launcher
    swaybg    # Wayland wallpaper
  ];
}

