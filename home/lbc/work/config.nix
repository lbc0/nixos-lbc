{repo, ...}: {
  programs.bash = {
    enable = true;
    shellAliases.nrs = "sudo nixos-rebuild switch --flake ${repo}#lbcw";

    initExtra = ''
      export BAO_ADDR=$(cat /run/secrets/openbao/address)
    '';
  };
}
