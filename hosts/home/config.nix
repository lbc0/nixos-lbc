{config, ...}: {
  sops.templates."gitlab-runner-lab.env".content = ''
    CI_SERVER_URL=https://gitlab.com
    CI_SERVER_TOKEN="$(cat /run/secrets/gitlab/token)"
  '';

  services.gitlab-runner = {
    enable = true;
    services.lab = {
      executor = "docker";
      dockerImage = "alpine:3";
      authenticationTokenConfigFile = config.sops.templates."gitlab-runner-lab.env".path;
    };
  };
}
