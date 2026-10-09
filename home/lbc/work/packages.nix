{pkgs, ...}: {
  home.packages = with pkgs; [
    krb5
    kubectl
    davfs2
    openbao
    jq
  ];
}
