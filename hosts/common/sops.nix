{ pkgs, inputs, config, ... }:

{
  imports =
    [
      inputs.sops-nix.nixosModules.sops
    ];

  sops.defaultSopsFile = secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  
  sops.age.keyFile = "/home/lbc/nixos-lbc/.ignore/.keys.txt";

  # importing my secrets
  sops.secrets."cportal/nac_url".owner = "lbc";
  sops.secrets."cportal/username".owner = "lbc";
  sops.secrets."cportal/password".owner = "lbc";
  sops.secrets."cportal/fw_domain".owner = "lbc";

  # GitHub Auth
  sops.secrets."github/username".owner = "lbc";
  sops.secrets."github/pass".owner = "lbc";
}
