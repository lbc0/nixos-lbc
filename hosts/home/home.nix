{ ... }:

{
  # Fingerprint reader
  #services.fprintd.enable = true;

  # Allow fingerprint for PAM (login, sudo, etc.)
  #security.pam.services.ly.fprintAuth = true;
  #security.pam.services.sudo.fprintAuth = true;
  #security.pam.services.login.fprintAuth = true;
}
