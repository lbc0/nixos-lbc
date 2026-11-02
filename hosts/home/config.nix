{config, ...}: {
  sops.secrets."gitlab/token" = {};
  sops.templates."gitlab-runner-lab.env".content = ''
    CI_SERVER_URL=https://gitlab.com
    CI_SERVER_TOKEN=${config.sops.placeholder."gitlab/token"}
  '';

  services.gitlab-runner = {
    enable = true;
    services.lab = {
      executor = "docker";
      dockerImage = "alpine:3";
      dockerExtraHosts = ["harbor.lab.test:192.168.150.20"];
      authenticationTokenConfigFile = config.sops.templates."gitlab-runner-lab.env".path;
      registrationFlags = ["--docker-security-opt=seccomp:unconfined"];
    };
  };

  networking.hosts."192.168.150.20" = ["harbor.lab.test"];

  # Copy pki/lab-ca.crt next to your NixOS config first (flakes can't read absolute paths outside the store)
  security.pki.certificateFiles = [./lab-ca.crt];
}
