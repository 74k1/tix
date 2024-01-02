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
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.darwin.follows = "";
    };
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # rix101 = {
    #   url = "github:reo101/rix101";
    # };
    ukiyo = {
      url = "github:74k1/ukiyo";
    };
    ChessSet = {
      url = "github:74k1/ChessSet";
    };
    wired = {
      url = "github:Toqozz/wired-notify";
    };
    nix-colors = {
      url = "github:misterio77/nix-colors";
    };
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nix-darwin
    , agenix
    , agenix-rekey
    # , rix101
    , ukiyo
    , ChessSet
    , wired
    , spicetify-nix
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      inherit (nixpkgs) lib;
    in {
      packages = {
        "x86_64-linux" =
          let
            pkgs = nixpkgs.legacyPackages."x86_64-linux";
          in
            import ./pkgs/default.nix { inherit pkgs; };
      };

      # Expose the necessary information in your flake so agenix-rekey
      # knows where it has to look for secrets and paths.
      #
      # Make sure that the pkgs passed here comes from the same nixpkgs version as
      # the pkgs used on your hosts with `nixosConfigurations`, otherwise the rekeyed
      # derivations will not be found!
      agenix-rekey = agenix-rekey.configure {
        userFlake = self;
        nodes = self.nixosConfigurations;
        # Example for colmena:
        # inherit ((colmena.lib.makeHive self.colmena).introspect (x: x)) nodes;
      };

      nixosModules = import ./modules/nixos;
      
      nixosConfigurations = {
        SEELE = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos/SEELE/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
                users.taki = import ./hosts/nixos/SEELE/home.nix;
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
        TOKYO-3 = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos/TOKYO-3/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
                users.taki = import ./hosts/nixos/TOKYO-3/home.nix;
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
      
      darwinConfigurations = {
        EVA = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";

          modules = [
           ./hosts/darwin/EVA/darwin-configuration.nix
           inputs.home-manager.darwinModules.home-manager
           {
            home-manager = {
              useGlobalPkgs = false;
              useUserPackages = true;
              users."74k1" = import ./hosts/darwin/EVA/darwin-home.nix;
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

      homeManagerModules = import ./modules/home-manager;
    };
}
