{...}: {
  services.glpiAgent = {
    enable = true;
    settings = {
      server = "https://glpi.cidra.ma/front/inventory.php";
      # tag = "users";

      # LIGHT=1 equivalent: skip software and process inventory
      "no-category" = ["software" "process"];
    };
  };
}
