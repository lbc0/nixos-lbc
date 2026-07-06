{
  pkgs,
  inputs,
  ...
}: let
  root = inputs.self;

  nac = pkgs.writeShellApplication {
    name = "nac";
    runtimeInputs = [pkgs.curl];
    text = builtins.readFile "${root}/.local/bin/nac";
  };

  bao-login = pkgs.writeShellApplication {
    name = "bao-login";
    runtimeInputs = [pkgs.openbao];
    text = builtins.readFile "${root}/.local/bin/bao-login";
  };
in {
  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake $HOME/nixos-lbc#lbcw";
    };

    initExtra = ''
      export BAO_ADDR=$(cat /run/secrets/openbao/address)
    '';
  };

  home.packages = [
    nac
    bao-login
  ];
}
