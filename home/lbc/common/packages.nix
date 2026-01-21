{ pkgs, ... }:
{
  # User packages (Wayland-friendly)
  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    fuzzel
    alacritty
    swaybg
    swaylock
    brave
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
  ];
}
