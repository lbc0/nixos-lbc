{
  description = "Lbc NixOS Flake";

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

    # QuickShell
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # NVF
    nvf = {
      url = "github:notashelf/nvf";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    sops-nix,
    home-manager,
    quickshell,
    nvf,
    ...
  }: let
    mkHost = {
      hostName,
      hostModule,
      homeModule,
      extraHomeImports ? [],
    }:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};

        modules = [
          hostModule
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            networking.hostName = hostName;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.backupFileExtension = "backup";
            home-manager.users.lbc.imports =
              [nvf.homeManagerModules.default homeModule] ++ extraHomeImports;
          }
        ];
      };
  in {
    nixosConfigurations = {
      lbcw = mkHost {
        hostName = "lbcw";
        hostModule = ./hosts/work.nix;
        homeModule = ./home/lbc/work.nix;
      };

      lbch = mkHost {
        hostName = "lbch";
        hostModule = ./hosts/home.nix;
        homeModule = ./home/lbc/home.nix;
      };
    };
  };
}
