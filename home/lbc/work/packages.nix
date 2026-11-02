{pkgs, ...}: {
  home.packages = with pkgs; [
    krb5
    kubectl
    kubectx
    fzf # interactive picker
    argocd
    kubernetes-helm
    davfs2
    openbao
    jq
  ];
}
