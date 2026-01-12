{ config, pkgs, lib, ... }:

{
  imports = [
    ./common/common.nix
    ./home/home.nix
  ];
}
