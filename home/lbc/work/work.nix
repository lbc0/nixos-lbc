{ pkgs, ... }:

{
  imports = [
    ./packages.nix
  ];
  
  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake $HOME/nixos-lbc#lbcw";
    };
    
    initExtra = ''
      export BAO_ADDR=$(cat /run/secrets/openbao/address)
    '';
  };

  home.packages = with pkgs; [
    (writeShellScriptBin "nac" ''
      curl -k -X POST "$(cat /run/secrets/cportal/nac_url)" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "fw_username=$(cat /run/secrets/cportal/username)&fw_password=$(cat /run/secrets/cportal/password)&fw_domain=$(cat /run/secrets/cportal/fw_domain)&action=fw_logon&fw_logon_type=logon"
    '')

    (writeShellScriptBin "gitup" ''
      git add . && read -rp "Commit message: " msg && git commit -m "$msg" && git push "https://$(cat /run/secrets/github/username):$(cat /run/secrets/github/pass)@github.com/lbc0/nixos-lbc.git"
    '')

    (writeShellScriptBin "bao-login" ''
      vault login -method userpass username=$(cat /run/secrets/openbao/username) password=$(cat /run/secrets/openbao/password)
    '')
  ];
}
