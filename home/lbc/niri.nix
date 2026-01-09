{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    fuzzel
    alacritty
    swaybg
    swaylock
    brave
    playerctl
    element-desktop
    quickshell
    sops
    (writeShellScriptBin "qstoggle" ''
      pgrep quickshell && pkill quickshell || quickshell
    '')

    (writeShellScriptBin "nac" ''
      curl -k -X POST  "$(cat /run/secrets/cportal/nac_url)"-H 'Content-Type: application/x-www-form-urlencoded' -d 'fw_username="$(cat /run/secrets/cportal/username)"&fw_password="$(cat /run/secrets/cportal/password)"&fw_domain="$(cat /run/secrets/cportal/fw_domain)"&action=fw_logon&fw_logon_type=logon'
    '')
  ];
}
