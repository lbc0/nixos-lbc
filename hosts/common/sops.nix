{ ... }:

{
  sops.defaultSopsFile = secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  
  sops.age.keyFile = "/home/lbc/nixos-lbc/.ignore/.keys.txt";

  # importing my secrets
  sops.secrets."cportal/nac_url".owner = "lbc";
  sops.secrets."cportal/username".owner = "lbc";
  sops.secrets."cportal/password".owner = "lbc";
  sops.secrets."cportal/fw_domain".owner = "lbc";

  # Vault Auth
  sops.secrets."vault/address".owner = "lbc";
  sops.secrets."vault/username".owner = "lbc";
  sops.secrets."vault/password".owner = "lbc";
  sops.secrets."vault/data".owner = "lbc";

  # GitHub Auth
  sops.secrets."github/username".owner = "lbc";
  sops.secrets."github/mail".owner = "lbc";
  sops.secrets."github/pass".owner = "lbc";

  # p7zip
  sops.secrets."p7zip/password".owner = "lbc";
}
