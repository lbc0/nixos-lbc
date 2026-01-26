{ pkgs, ... }:
{
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
    element-desktop
    quickshell
    sops
    tree

    # Programming languages
    python315

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
  ];
}
