{ config, lib, pkgs, host, ... }:

{
  # imports
  imports = [
    ./common/common.nix
    ./common/sops.nix
    ./work/hardware.nix
  ];
}
