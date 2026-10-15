{pkgs, ...}: {
  home.packages = with pkgs; [
    krb5
    kubectl
    kubernetes-helm
    davfs2
    openbao
    jq
  ];
}
