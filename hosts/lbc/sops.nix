{ pkgs, inputs, config, ... }:

{
  imports =
    [
      inputs.sops-nix.nixosModules.sops
    ];

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  
  sops.age.keyFile = "./.keys.txt";

  sops.secrets.example_key = { };
  sops.secrets."myservice/my_subdir/my_secret" = {
    owner = "lbc";
  };
}
