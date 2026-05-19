{pkgs, ...}: {
  # User packages (Wayland-friendly)
  home.packages = with pkgs; [
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    fuzzel
    yazi
    alacritty
    nautilus
    swaybg
    swaylock
    swayidle
    brave
    telegram-desktop
    playerctl
    # element-desktop
    quickshell
    sops
    tree
    p7zip
    localsend

    # Programming languages
    (python3.withPackages (ps:
      with ps; [
        bcrypt # package
      ]))
    go

    # X11
    xwayland-satellite

    # Bin Scripts
    (writeShellScriptBin "qstoggle" ''
      pgrep quickshell && pkill quickshell || quickshell
    '')

    (writeShellScriptBin "screenOnOff" ''
      action="$1"  # on | off
      niri msg outputs \
        | sed -n 's/^Output .* (\(.*\))$/\1/p' \
        | while read -r output; do
            niri msg output "$output" "$action"
          done
    '')

    (writeShellScriptBin "swaylockPNG" ''
      swaylock -i /home/lbc/nixos-lbc/assets/walls/desktop.png -s fill
    '')

    (symlinkJoin {
      # <-- replaces bare element-desktop
      name = "element-desktop";
      paths = [element-desktop];
      buildInputs = [makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/element-desktop \
          --run '
            read -s -p "Enter password: " input
            echo ""
            stored=$(cat /run/secrets/p7zip/pass)
            if ! python3 -c "import bcrypt,sys;sys.exit(0 if bcrypt.checkpw(b\"$input\",b\"$stored\") else 1)"; then
              echo "Wrong password."
              exit 1
            fi
          '

        # Override the .desktop file to use a terminal with the password prompt
        sed -i "s|Exec=element-desktop|Exec=alacritty -e $out/bin/element-desktop|g" $out/share/applications/element-desktop.desktop
      '';
    })
  ];
}
