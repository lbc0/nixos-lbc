{ config, pkgs, lib, ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake $HOME/nixos-lbc#lbc-work";
      };
    };

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
    tree
    (writeShellScriptBin "qstoggle" ''
      pgrep quickshell && pkill quickshell || quickshell
    '')

    (writeShellScriptBin "nac" ''
      curl -k -X POST "$(cat /run/secrets/cportal/nac_url)" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "fw_username=$(cat /run/secrets/cportal/username)&\
        fw_password=$(cat /run/secrets/cportal/password)&\
        fw_domain=$(cat /run/secrets/cportal/fw_domain)&\
        action=fw_logon&fw_logon_type=logon"
    '')
  ];
}
