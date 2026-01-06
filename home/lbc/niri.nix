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
    (writeShellScriptBin "qstoggle" ''
      pgrep quickshell && pkill quickshell || quickshell
    '')

    (writeShellScriptBin "nac" ''
      curl -k -X POST https://cportal.henceforth.co.ma:4100/wgcgi.cgi -H 'Content-Type: application/x-www-form-urlencoded' -d 'fw_username=a.lbouchouari&fw_password=KAli123   &fw_domain=henceforth.local&action=fw_logon&fw_logon_type=logon'
    '')
  ];
}
