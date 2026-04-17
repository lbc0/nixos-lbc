{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kubectl
    vault
    openbao
    jq
  ];
}
