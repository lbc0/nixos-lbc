{repo, ...}: {
  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ${repo}#lbcw";
      k = "kubectl";
      kx = "kubectx";
      kn = "kubens";
    };

    initExtra = ''
      export BAO_ADDR=$(cat /run/secrets/openbao/address)
      source <(kubectl completion bash)
      complete -o default -F __start_kubectl k
    '';
  };
}
