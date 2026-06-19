{ ... }: {
  imports = [
    ./common/common.nix
    ./common/sops.nix
    ./work/hardware.nix
    ./work/drive.nix
    ./work/sops.nix
  ];
}
