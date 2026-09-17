{...}: {
  imports = [
    ./hardware.nix
    ./swap-luks.nix
    ./drive.nix
    ./sops.nix
    ../common
  ];
}
