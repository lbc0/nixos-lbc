{repo, ...}: {
  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ${repo}#lbch";
      lab = "cd ~/platformSec && nix develop ./.devshell";
    };
  };
}
