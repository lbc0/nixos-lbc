{...}: {
  # importing my secrets
  sops.secrets."cportal/nac_url".owner = "lbc";
  sops.secrets."cportal/username".owner = "lbc";
  sops.secrets."cportal/password".owner = "lbc";
  sops.secrets."cportal/fw_domain".owner = "lbc";

  # OpenBao Auth
  sops.secrets."openbao/address".owner = "lbc";
  sops.secrets."openbao/username".owner = "lbc";
  sops.secrets."openbao/password".owner = "lbc";

  # ArgoCD Auth
  sops.secrets."argocd/server".owner = "lbc";
  sops.secrets."argocd/username".owner = "lbc";
  sops.secrets."argocd/password".owner = "lbc";
}
