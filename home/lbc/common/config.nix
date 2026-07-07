{
  config,
  lib,
  pkgs,
  profile,
  store,
  repo,
  ...
}: let
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Only relevant configs
  configs = {
    niri = "niri/${profile}/config";
    quickshell = "quickshell";
    swayidle = "swayidle";
  };
in {
  # Basic Home Manager setup
  home.username = "lbc";
  home.stateVersion = "25.11";
  home.sessionVariables = {
    EDITOR = "nvim";
    DOTFILES_STORE = "${store}";
    DOTFILES_REPO = "${repo}";
  };

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
        export SOPS_AGE_KEY_FILE="${store}/.ignore/.keys.txt"
      '';
    };

    neovim.defaultEditor = true;
    onlyoffice.enable = true;
  };

  # Dotfiles symlinks
  xdg.configFile =
    builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${repo}/config/${subpath}";
      recursive = true;
    })
    configs;
}
