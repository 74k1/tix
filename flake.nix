{
  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  };
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
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      # NOTE: not overriding since NixOS-WSL is flaky (relies on stable)
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    arion = {
      url = "github:hercules-ci/arion";
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
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      # url = "github:hyprwm/Hyprland";
    };
    stylix = {
      url = "github:danth/stylix";
    };
    #rix101 = {
    #  url = "github:reo101/rix101";
    #};
    ukiyo = {
      url = "github:74k1/ukiyo";
    };
    ChessSet = {
      url = "github:74k1/ChessSet";
    };
    wired-notify = {
      url = "github:Toqozz/wired-notify";
    };
    vpnconfinement = {
      url = "github:Maroka-chan/VPN-Confinement";
      #url = "github:74k1/VPN-Confinement";
    };
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nix-darwin
    , arion
    , agenix
    , agenix-rekey
    , deploy-rs
    , hyprland
    , stylix
    # , rix101
    , ukiyo
    , ChessSet
    , wired-notify
    # , simple-nixos-mailserver
    , vpnconfinement
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
        nodes = {
          inherit (self.nixosConfigurations) cyberia eiri;
        };
        # Example for colmena:
        # inherit ((colmena.lib.makeHive self.colmena).introspect (x: x)) nodes;
      };

      nixosModules = import ./modules/nixos;
      
      nixosConfigurations = {
        # nixosConfigurations.default = lib.nixosSystem {
        #   specialArgs = { inherit inputs; };
        #   modules = [
        #     inputs.stylix.nixosModules.stylix
        #   ];
        # };
        wired = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos/wired/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            #stylix.nixosModules.stylix
            # stylix.homeManagerModules.stylix
            {
              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
                users.taki = import ./hosts/nixos/wired/home.nix;
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
        cyberia = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos/cyberia/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
                users.taki = import ./hosts/nixos/cyberia/home.nix;
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
        eiri = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos/eiri/configuration.nix
            inputs.arion.nixosModules.arion
            inputs.home-manager.nixosModules.home-manager
            inputs.vpnconfinement.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
                users.taki = import ./hosts/nixos/eiri/home.nix;
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
        knights = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos/knights/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
                users.taki = import ./hosts/nixos/knights/home.nix;
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
        morpheus = lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./hosts/nixos/morpheus/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
                users.taki = import ./hosts/nixos/morpheus/home.nix;
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
        psyche = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos/psyche/configuration.nix
            # inputs.home-manager.nixosModules.home-manager
            # {
            #   home-manager = {
            #     useGlobalPkgs = false;
            #     useUserPackages = true;
            #     users.taki = import ./hosts/nixos/psyche/home.nix;
            #     extraSpecialArgs = {
            #       inherit inputs outputs;
            #     };
            #   };
            # }
          ];
          specialArgs = {
            inherit inputs outputs;
          };
        };
      };

      # darwinModules = import ./modules/darwin;
      # 
      # darwinConfigurations = {
      #   EVA = nix-darwin.lib.darwinSystem {
      #     system = "aarch64-darwin";

      #     modules = [
      #      ./hosts/darwin/EVA/darwin-configuration.nix
      #      inputs.home-manager.darwinModules.home-manager
      #      {
      #       home-manager = {
      #         useGlobalPkgs = false;
      #         useUserPackages = true;
      #         users."74k1" = import ./hosts/darwin/EVA/darwin-home.nix;
      #         extraSpecialArgs = {
      #           inherit inputs outputs;
      #         };
      #       };
      #      }
      #     ];
      #     specialArgs = {
      #       inherit inputs outputs;
      #     };
      #   };
      # };

      homeManagerModules = import ./modules/home-manager;

      devShells.x86_64-linux =
        let
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.git
              agenix-rekey.packages."x86_64-linux".agenix-rekey
              deploy-rs.packages."x86_64-linux".deploy-rs
            ];
          };
          with-wireguard-tools = pkgs.mkShell {
            buildInputs = with pkgs; [
              wireguard-tools
            ];
          };
          macchina = pkgs.mkShell {
            buildInputs = with pkgs; [
              macchina
            ];
          };
        };

      deploy.nodes = {
        eiri = {
          hostname = "255.255.255.255"; # should change this to 10.0.0.1 someday, when i have wg on cyberia
          sshOpts = [ "-p" "22" ];
          sshUser = "taki";
          user = "root";
          interactiveSudo = true;
          autoRollback = true;
          magicRollback = true;
          remoteBuild = false;
          profiles.system = {
            user = "root";
            # Backreference to the flake output for the knights configuration VVV
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.eiri;
          };
        };
        knights = {
          hostname = "10.100.0.2";
          sshOpts = [ "-p" "22" ];
          sshUser = "taki";
          user = "root";
          interactiveSudo = true;
          autoRollback = true;
          magicRollback = true;
          remoteBuild = false;
          profiles.system = {
            user = "root";
            # Backreference to the flake output for the knights configuration VVV
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.knights;
          };
        };
        morpheus = {
          hostname = "192.168.1.61"; # temporarily
          sshOpts = [ "-p" "22" ];
          sshUser = "taki";
          user = "root";
          interactiveSudo = true;
          autoRollback = true;
          magicRollback = true;
          remoteBuild = false; # important, weak device
          profiles.system = {
            user = "root";
            # Backreference to the flake output for the knights configuration VVV
            path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.morpheus;
          };
        };
      };
    };
}
