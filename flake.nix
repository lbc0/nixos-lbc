{
  description = "Lbc NixOS Flake with Noctalia";

  inputs = {
    # Stable system
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Unstable system
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager stable
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # SOPS
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    #noctalia = {
    #  url = "github:noctalia-dev/noctalia-shell";
    #  inputs.nixpkgs.follows = "nixpkgs-unstable";
    #};

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

  };

  outputs = inputs@{ self, nixpkgs, sops-nix, home-manager, quickshell, ... }:
  {
    nixosConfigurations = {

      lbc-work = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
          host = "work";
        };

        modules = [
          ./hosts/common/default.nix

          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager

          {
            networking.hostName = "lbc";

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.lbc = import ./home/lbc/default.nix;

            home-manager.backupFileExtension = "backup";
          }
        ];
      };

      lbc-home = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
          host = "home";
        };

        modules = [
          ./hosts/common/default.nix

          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager

          {
            networking.hostName = "lbc";

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.lbc = import ./home/lbc/default.nix;

            home-manager.backupFileExtension = "backup";
          }
        ];
      };

    };
  };
}
