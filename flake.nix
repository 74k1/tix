{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
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
    , rix101
    , ukiyo
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      inherit (nixpkgs) lib;
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        taki = lib.nixosSystem {
          inherit system;

          modules = [
            ./configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
                users.taki = import ./home.nix;
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
    };
}
