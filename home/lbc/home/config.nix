{...}: {
  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake $HOME/nixos-lbc#lbch";
    };
  };

  home.sessionVariables.DOTFILES_LIVE = "$HOME/nixos-lbc";
}
