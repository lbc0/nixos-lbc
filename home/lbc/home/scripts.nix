{...}: {
  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake $HOME/nixos-lbc#lbch";
    };

    initExtra = ''
      export DOTFILES_LIVE=$HOME/nixos-lbc
    '';
  };
}
