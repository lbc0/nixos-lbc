{pkgs, ...}: {
  home.packages = with pkgs; [
    krb5
    kubectl
    argocd
    kubernetes-helm
    davfs2
    openbao
    jq
  ];
}
