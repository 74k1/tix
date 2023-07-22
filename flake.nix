{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rix101 = {
      url = "github:reo101/rix101";
    };
    ukiyo = {
      url = "github:74k1/ukiyo";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nix-darwin
    , rix101
    , ukiyo
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      inherit (nixpkgs) lib;
    in {
      nixosConfigurations = {
        SEELE = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./machines/nixos/SEELE/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
                users.taki = import ./machines/nixos/home.nix;
                extraSpecialArgs = {
                  inherit inputs outputs;
                };
              };
            }
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
      };

      nixosModules = import ./modules/nixos;

      darwinConfigurations = {
        EVA = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";

          modules = [
           ./machines/darwin/EVA/darwin-configuration.nix
           inputs.home-manager.darwinModules.home-manager
           {
            home-manager = {
              useGlobalPkgs = false;
              useUserPackages = true;
              users."74k1" = import ./machines/darwin/darwin-home.nix;
              extraSpecialArgs = {
                inherit inputs outputs;
              };
            };
           }
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
      };

      darwinModules = import ./modules/darwin;

      homeManagerModules = import ./modules/home-manager;
    };
}
