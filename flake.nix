{
  description = "Lbc NixOS Flake with Noctalia";

  inputs = {
    # Stable system
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Home Manager stable
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Unstable only for Noctalia
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, noctalia, ... }:
  {
    nixosConfigurations.lbc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      # Needed so noctalia.nix can access inputs
      specialArgs = { inherit inputs; };

      modules = [
        ./hosts/lbc
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.lbc = import ./home/lbc;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}
