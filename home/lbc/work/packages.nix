{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kubectl
    vault
    jq
  ];
}
