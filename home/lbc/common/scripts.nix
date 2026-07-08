{
  pkgs,
  inputs,
  store,
  ...
}: let
  pythonWithBcrypt = pkgs.python3.withPackages (ps: [ps.bcrypt]);

  # Increases/decreases brightness on the laptop panel (backlight) and all
  # connected external monitors (DDC/CI via ddcutil) together, keeping them in sync.
  brightness-all = pkgs.writeShellApplication {
    name = "brightness-all";
    runtimeInputs = [pkgs.brightnessctl pkgs.ddcutil];
    text = builtins.readFile "${store}/.local/bin/brightness-all";
  };

  # Toggles quickshell: kills it if running, launches it if not.
  qstoggle = pkgs.writeShellApplication {
    name = "qstoggle";
    runtimeInputs = [pkgs.procps inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default];
    text = builtins.readFile "${store}/.local/bin/qstoggle";
  };

  # Turns all connected display outputs on or off via niri msg (usage: screen-on-off on|off).
  screen-on-off = pkgs.writeShellApplication {
    name = "screen-on-off";
    runtimeInputs = [pkgs.gnused];
    text = builtins.readFile "${store}/.local/bin/screen-on-off";
  };

  # Locks the screen with swaylock using a fixed desktop wallpaper image.
  swaylock-png = pkgs.writeShellApplication {
    name = "swaylock-png";
    runtimeInputs = [pkgs.swaylock];
    text =
      builtins.replaceStrings
      ["@WALLPAPER@"]
      ["${store}/assets/walls/desktop.png"]
      (builtins.readFile "${store}/.local/bin/swaylock-png");
  };

  # Brings up the "Hotspot" NetworkManager connection profile.
  hotspot-up = pkgs.writeShellApplication {
    name = "hotspot-up";
    runtimeInputs = [pkgs.networkmanager];
    text = builtins.readFile "${store}/.local/bin/hotspot-up";
  };

  # Stages all changes, prompts for a commit message, commits, and pushes
  # to the nix-work branch — a quick shorthand for the repo's usual git flow.
  gitup = pkgs.writeShellApplication {
    name = "gitup";
    runtimeInputs = [pkgs.git];
    text = builtins.readFile "${store}/.local/bin/gitup";
  };

  # Watches for keyboard/mouse input while an Element "Element | General" room
  # is focused; if input is detected while that room stays focused, kills
  # element-desktop and locks the screen. A privacy guard against accidental
  # screen-shares/screenshots of a sensitive chat room.
  room-lock-guard = pkgs.writeShellApplication {
    name = "room-lock-guard";
    runtimeInputs = [pkgs.libinput pkgs.python3 pkgs.gnugrep pkgs.procps swaylock-png];
    text = builtins.readFile "${store}/.local/bin/room-lock-guard";
  };

  # Wraps element-desktop with a bcrypt password prompt (via a private,
  # self-contained python+bcrypt environment) before allowing launch, and
  # rewrites its .desktop entry to run inside alacritty so the prompt is visible.
  # element-desktop-wrapped = pkgs.symlinkJoin {
  #   name = "element-desktop";
  #   paths = [pkgs.element-desktop];
  #   buildInputs = [pkgs.makeWrapper];
  #   postBuild = ''
  #     wrapProgram $out/bin/element-desktop \
  #       --run '
  #         read -s -p "Enter password: " input
  #         echo ""
  #         stored=$(cat /run/secrets/p7zip/pass)
  #         if ! ${pythonWithBcrypt}/bin/python3 -c "import bcrypt,sys;sys.exit(0 if bcrypt.checkpw(b\"$input\",b\"$stored\") else 1)"; then
  #           echo "Wrong password."
  #           exit 1
  #         fi
  #       '
  #     sed -i "s|Exec=element-desktop|Exec=alacritty -e $out/bin/element-desktop|g" $out/share/applications/element-desktop.desktop
  #   '';
  # };

  # Mounts an encrypted (gocryptfs) profile directory for Element, prompting
  # for the passphrase, launches Element against it, and unmounts on exit.
  # Wrong passphrase = mount fails = no plaintext data ever exists on disk.
  element-locked = pkgs.writeShellApplication {
    name = "element-locked";
    runtimeInputs = [pkgs.gocryptfs pkgs.fuse pkgs.util-linux pkgs.element-desktop];
    text = builtins.readFile "${store}/.local/bin/element-locked";
  };

  # Repoints the element-desktop binary name at element-locked and rewrites
  # the .desktop entry to launch inside alacritty so the passphrase prompt
  # (and any gocryptfs/mount errors) are visible.
  element-desktop-locked = pkgs.symlinkJoin {
    name = "element-desktop";
    paths = [pkgs.element-desktop];
    postBuild = ''
      rm -f $out/bin/element-desktop
      ln -s ${element-locked}/bin/element-locked $out/bin/element-desktop
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
    room-lock-guard
    element-desktop-locked
  ];
}
