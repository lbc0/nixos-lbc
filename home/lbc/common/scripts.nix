{
  pkgs,
  inputs,
  store,
  ...
}: let
  theme = import ./theme.nix;

  # pythonWithBcrypt = pkgs.python3.withPackages (ps: [ps.bcrypt]);
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
      ["@WALLPAPER@" "@RING@" "@INSIDE@" "@TEXT@"]
      ["${store}/assets/walls/desktop.png" "#${theme.blue}" "#${theme.bg}" "#${theme.fg}"]
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

  # Rofi-based passphrase prompt for gocryptfs's -extpass, themed to match
  # the rest of the system via rofi.nix. No args with spaces (gocryptfs
  # splits -extpass on whitespace), so this wraps the -p flag safely.
  rofi-passphrase = pkgs.writeShellApplication {
    name = "rofi-passphrase";
    runtimeInputs = [pkgs.rofi];
    text = builtins.readFile "${store}/.local/bin/rofi-passphrase";
  };

  # Mounts an encrypted (gocryptfs) profile directory for Element via a
  # themed rofi passphrase prompt, launches Element against it, and
  # unmounts on exit. Wrong passphrase = mount fails = no plaintext data
  # ever exists on disk. No terminal needed anywhere in this flow.
  element-locked = pkgs.writeShellApplication {
    name = "element-locked";
    runtimeInputs = [
      pkgs.gocryptfs
      pkgs.fuse
      pkgs.util-linux
      pkgs.libnotify
      pkgs.element-desktop
      rofi-passphrase
    ];
    text = builtins.readFile "${store}/.local/bin/element-locked";
  };

  # Repoints the element-desktop binary name at element-locked. No .desktop
  # Exec rewrite needed anymore — rofi handles the prompt, no terminal
  # wrapper required.
  element-desktop-locked = pkgs.symlinkJoin {
    name = "element-desktop";
    paths = [pkgs.element-desktop];
    postBuild = ''
      rm -f $out/bin/element-desktop
      ln -s ${element-locked}/bin/element-locked $out/bin/element-desktop
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
    rofi-passphrase
    element-desktop-locked
  ];
}
