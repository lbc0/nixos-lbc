{ config, pkgs, lib, ... }:

{
  imports = [
    ./common/common.nix
    ./work/work.nix
  ];
}
