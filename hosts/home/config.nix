{...}: {
  services.gitlab-runner = {
    enable = true;
    services.lab = {
      executor = "docker";
      dockerImage = "alpine:3";
      authenticationTokenConfigFile = "/run/secrets/gitlab/token";
    };
  };
}
