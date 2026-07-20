{pkgs, ...}: {
  home.packages = with pkgs; [
    kubectl
    davfs2
    openbao
    jq
  ];
}
