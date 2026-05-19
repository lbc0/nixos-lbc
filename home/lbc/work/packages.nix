{pkgs, ...}: {
  home.packages = with pkgs; [
    kubectl
    vault
    davfs2
    openbao
    jq
  ];
}
