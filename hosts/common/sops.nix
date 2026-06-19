{config, ...}: {
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/lbc/nixos-lbc/.ignore/.keys.txt";

  # importing my secrets
  sops.secrets."cportal/nac_url".owner = "lbc";
  sops.secrets."cportal/username".owner = "lbc";
  sops.secrets."cportal/password".owner = "lbc";
  sops.secrets."cportal/fw_domain".owner = "lbc";

  # OpenBao Auth
  sops.secrets."openbao/address".owner = "lbc";
  sops.secrets."openbao/username".owner = "lbc";
  sops.secrets."openbao/password".owner = "lbc";
  sops.secrets."openbao/data".owner = "lbc";

  # GitHub Auth
  sops.secrets."github/username".owner = "lbc";
  sops.secrets."github/mail".owner = "lbc";
  sops.secrets."github/pass".owner = "lbc";

  # p7zip
  sops.secrets."p7zip/password".owner = "lbc";
  sops.secrets."p7zip/pass".owner = "lbc";
}
