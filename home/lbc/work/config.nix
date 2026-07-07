{...}: {
  programs.bash = {
    enable = true;
    shellAliases.nrs = "sudo nixos-rebuild switch --flake $HOME/nixos-lbc#lbcw";

    initExtra = ''
      export BAO_ADDR=$(cat /run/secrets/openbao/address)
    '';
  };

  home.sessionVariables.DOTFILES_LIVE = "$HOME/nixos-lbc";
}
