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
    swaybg
    swaylock
    swayidle
    brave
    telegram-desktop
    playerctl
    quickshell
    sops
    tree
    p7zip
    localsend
    libinput
    zathura
    xournalpp
    mousepad
    wdisplays # Monitors arrangement
    docker

    # Programming languages
    python3
    go

    # X11
    xwayland-satellite
  ];
}
