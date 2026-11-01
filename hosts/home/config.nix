{...}: {
  services.gitlab-runner = {
    enable = true;
    services.lab = {
      executor = "docker";
      dockerImage = "alpine:3";
      #      authenticationTokenConfigFile = "/var/lib/secrets/gitlab-runner-lab.env";
    };
  };
}
