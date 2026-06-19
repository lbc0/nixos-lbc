{...}: {
  imports = [
    ./common.nix
    ./packages.nix
    ./mpv.nix
    ./nvf
    ./gtk/nordic.nix # Switch between themes: adwaita, rosepine, and nordic
  ];
}
