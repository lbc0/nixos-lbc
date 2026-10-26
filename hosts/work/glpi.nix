{...}: {
  services.glpiAgent = {
    enable = true;
    settings = {
      server = "$(cat /run/secrets/glpi/url)";
      # tag = "users";

      # LIGHT=1 equivalent: skip software and process inventory
      "no-category" = ["software" "process"];
    };
  };
}
