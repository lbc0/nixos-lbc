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
  theme = import ./theme.nix;

  # Whole-directory, live-edited configs (out-of-store symlink, no rebuild
  # needed to see changes).
  configs = {
    niri = "niri/${profile}/config";
    quickshell = "quickshell";
    swayidle = "swayidle";
  };

  # Generated from theme.nix — NOT live-edited, changes only via rebuild.
  themeQml = pkgs.writeText "Theme.qml" ''
    pragma Singleton
    import QtQuick

    QtObject {
        readonly property color bg: "#${theme.bg}"
        readonly property color bgAlt: "#${theme.bgAlt}"
        readonly property color bgHighlight: "#${theme.bgHighlight}"
        readonly property color fg: "#${theme.fg}"
        readonly property color fgDim: "#${theme.fgDim}"
        readonly property color red: "#${theme.red}"
        readonly property color orange: "#${theme.orange}"
        readonly property color yellow: "#${theme.yellow}"
        readonly property color green: "#${theme.green}"
        readonly property color cyan: "#${theme.cyan}"
        readonly property color blue: "#${theme.blue}"
        readonly property color purple: "#${theme.purple}"
        readonly property string fontFamily: "${theme.font}"
        readonly property int fontSize: ${toString theme.fontSize}
    }
  '';
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
        export SOPS_AGE_KEY_FILE="${repo}/.ignore/.keys.txt"
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

  # Copies the generated Theme.qml content into place as a plain file
  # (not a store symlink), so it behaves like a normal file on disk while
  # still being fully derived from theme.nix on every `nrs`.
  home.activation.quickshellTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/.config/quickshell/Common"
    cp -f ${themeQml} "$HOME/.config/quickshell/Common/Theme.qml"
    chmod 644 "$HOME/.config/quickshell/Common/Theme.qml"
  '';
}
