{pkgs, ...}: {
  home.packages = with pkgs; [
    krb5
    kubectl
    kubectx
    argocd
    kubernetes-helm
    davfs2
    openbao
    jq
  ];
}
