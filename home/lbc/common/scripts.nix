{
  pkgs,
  inputs,
  ...
}: let
  root = inputs.self;

  pythonWithBcrypt = pkgs.python3.withPackages (ps: [ps.bcrypt]);

  brightness-all = pkgs.writeShellApplication {
    name = "brightness-all";
    runtimeInputs = [pkgs.brightnessctl pkgs.ddcutil];
    text = builtins.readFile "${root}/.local/bin/brightness-all";
  };

  qstoggle = pkgs.writeShellApplication {
    name = "qstoggle";
    runtimeInputs = [pkgs.procps inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default];
    text = builtins.readFile "${root}/.local/bin/qstoggle";
  };

  screen-on-off = pkgs.writeShellApplication {
    name = "screen-on-off";
    runtimeInputs = [pkgs.gnused];
    text = builtins.readFile "${root}/.local/bin/screen-on-off";
  };

  swaylock-png = pkgs.writeShellApplication {
    name = "swaylock-png";
    runtimeInputs = [pkgs.swaylock];
    text = builtins.readFile "${root}/.local/bin/swaylock-png";
  };

  hotspot-up = pkgs.writeShellApplication {
    name = "hotspot-up";
    runtimeInputs = [pkgs.networkmanager];
    text = builtins.readFile "${root}/.local/bin/hotspot-up";
  };

  gitup = pkgs.writeShellApplication {
    name = "gitup";
    runtimeInputs = [pkgs.git];
    text = builtins.readFile "${root}/.local/bin/gitup";
  };

  element-desktop-wrapped = pkgs.symlinkJoin {
    name = "element-desktop";
    paths = [pkgs.element-desktop];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/element-desktop \
        --run '
          read -s -p "Enter password: " input
          echo ""
          stored=$(cat /run/secrets/p7zip/pass)
          if ! ${pythonWithBcrypt}/bin/python3 -c "import bcrypt,sys;sys.exit(0 if bcrypt.checkpw(b\"$input\",b\"$stored\") else 1)"; then
            echo "Wrong password."
            exit 1
          fi
        '
      sed -i "s|Exec=element-desktop|Exec=alacritty -e $out/bin/element-desktop|g" $out/share/applications/element-desktop.desktop
    '';
  };
in {
  home.packages = [
    brightness-all
    qstoggle
    screen-on-off
    swaylock-png
    hotspot-up
    gitup
    element-desktop-wrapped
  ];
}
