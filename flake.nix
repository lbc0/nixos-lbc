{
  description = "Lbc NixOS Flake";

  inputs = {
    # Stable system
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # Unstable system
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager stable
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Obsidian Extensions
    obsidian-extensions = {
      url = "github:karaolidis/nix-obsidian-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Enabling Secure Boot with lanzaboot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    sops-nix,
    home-manager,
    quickshell,
    nvf,
    obsidian-extensions,
    ...
  }: let
    store = self; # flake source as copied into /nix/store
    repo = "/home/lbc/nixos-lbc"; # live checkout on disk

    mkHost = {
      hostName,
      hostModule,
      homeModule,
      extraHomeImports ? [],
      profile, # home/work
    }:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs profile store repo;};

        modules = [
          hostModule
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            networking.hostName = hostName;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs profile store repo;};
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
        hostModule = ./hosts/work;
        homeModule = ./home/lbc/work;
        profile = "work";
      };

      lbch = mkHost {
        hostName = "lbch";
        hostModule = ./hosts/home;
        homeModule = ./home/lbc/home;
        profile = "home";
      };
    };
  };
}
