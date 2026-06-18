{
  config,
  lib,
  pkgs,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/nixos-lbc/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Only relevant configs
  configs = {
    niri = "niri";
    quickshell = "quickshell";
    swayidle = "swayidle";
  };
in {
  imports = [
    ./nvf.nix
    ./packages.nix
    ./mpv.nix
    ./gtk/gtk3.nix
  ];

  # Basic Home Manager setup
  home.username = "lbc";
  home.homeDirectory = "/home/lbc";
  home.stateVersion = "25.11";

  programs = {
    # Github
    git = {
      enable = true;
      settings = {
        user = {
          name = "lbc0";
          email = "lbc0@gmail.com";
        };
        credential.helper = lib.getExe (pkgs.writeShellScriptBin "git-credential-sops" ''
          printf "username=%s\npassword=%s\n" \
            "$(cat /run/secrets/github/username)" \
            "$(cat /run/secrets/github/pass)"
        '');
      };
    };

    bash = {
      enable = true;
      initExtra = ''
        export PS1="\[\e[38;5;75m\]\u@\h \[\e[38;5;113m\]\w \[\e[38;5;189m\]\$ \[\e[0m\]"
        export SOPS_AGE_KEY_FILE="${config.home.homeDirectory}/home/lbc/nixos-lbc/.ignore/.keys.txt"
      '';
    };

    neovim.defaultEditor = true;

    onlyoffice = {
      enable = true;
    };

    #dms#    # Dank Linux
    #dms#    dank-material-shell = {
    #dms#      enable = true;
    #dms#      enableSystemMonitoring = true;
    #dms#      dgop.package = inputs.dgop.packages.${pkgs.system}.default;
    #dms#    };
  };

  # Dotfiles symlinks
  xdg.configFile =
    builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;
}
