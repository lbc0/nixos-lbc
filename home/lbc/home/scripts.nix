{inputs, ...}: {
  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ${inputs.self}#lbch";
    };

    initExtra = ''
      export DOTFILES_LIVE="$HOME/nixos-lbc"
    '';
  };
}
