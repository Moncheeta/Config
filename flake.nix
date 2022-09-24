{
  description = "Moncheeta's Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; 
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }:
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        desktop = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            ./modules/boot/desktop
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.moncheeta = import ./home.nix;
              home-manager.extraSpecialArgs = { inherit hyprland; };
            }
          ];
        };
        laptop = lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            ./modules/boot/laptop
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.moncheeta = import ./home.nix;
              home-manager.extraSpecialArgs = { inherit hyprland; };
            }
          ];
        };
      };
    };
}
