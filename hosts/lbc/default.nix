{ ... }:
{
  imports = [
    ./hardware.nix
    ./boot.nix
    ./networking.nix
    ./locale.nix
    ./users.nix
    ./fonts.nix
  ];
}
