{
  pkgs,
  inputs,
  ...
}: let
  root = inputs.self;

  # Logs in to the captive-portal-style network access control (NAC) page
  # using credentials stored in sops secrets.
  nac = pkgs.writeShellApplication {
    name = "nac";
    runtimeInputs = [pkgs.curl];
    text = builtins.readFile "${root}/.local/bin/nac";
  };

  # Logs in to OpenBao (Vault-compatible secrets manager) using userpass auth
  # with credentials stored in sops secrets.
  bao-login = pkgs.writeShellApplication {
    name = "bao-login";
    runtimeInputs = [pkgs.openbao];
    text = builtins.readFile "${root}/.local/bin/bao-login";
  };
in {
  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ${root}#lbcw";
    };

    initExtra = ''
      export DOTFILES_LIVE="$HOME/nixos-lbc"
      export BAO_ADDR=$(cat /run/secrets/openbao/address)
    '';
  };

  home.packages = [
    nac
    bao-login
  ];
}
