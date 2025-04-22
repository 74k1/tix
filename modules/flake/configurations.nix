{
  lib,
  config,
  self,
  inputs,
  withSystem,
  allSecrets,
  ...
}: let
  lib = config._module.args.lib;
  outputs = self;

  allSecrets =
    lib.rageImportEncrypted ../../secrets/secrets.nix.age;

  mkNixosHost = hostname: {
    system,
    home-manager ? true,
  }:
    lib.nixosSystem {
      inherit system;
      # the `perSystem` function gives you access to the shit inside the `perSystem` blocks
      pkgs = withSystem system ({pkgs, ...}: pkgs);
      modules =
        [
          # Main config
          "${inputs.self}/hosts/nixos/${hostname}/configuration.nix"
          # nix-topology
          inputs.nix-topology.nixosModules.default
        ]
        ++ lib.optionals home-manager [
          # Home Manager
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              # Use same `pkgs` as the NixOS above
              useGlobalPkgs = true;
              useUserPackages = true;
              users.taki = import "${inputs.self}/hosts/nixos/${hostname}/home.nix";
              extraSpecialArgs = {
                inherit inputs outputs;
              };
              backupFileExtension = "backup";
            };
          }
        ];
      specialArgs = {
        inherit inputs outputs;
        inherit allSecrets;
        inherit lib;
      };
    };

  mkNixDarwinHost = hostname: {
    system,
    home-manager ? true,
  }:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      pkgs = withSystem system ({pkgs, ...}: pkgs);

      modules = [
        # Main config
        "${inputs.self}/hosts/darwin/${hostname}/darwin-configuration.nix"

        # Home Manager
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager = {
            # Use same `pkgs` as the NixOS above
            useGlobalPkgs = true;
            useUserPackages = true;
            users.taki = import "${inputs.self}/hosts/darwin/${hostname}/darwin-home.nix";
            extraSpecialArgs = {
              inherit inputs outputs;
            };
            backupFileExtension = "backup";
          };
        }
      ];

      specialArgs = {
        inherit inputs outputs;
        inherit allSecrets;
        inherit lib;
      };
    };

  mkDeployNode = {
    hostname,
    system,
    # "nixos" or "darwin"
    configType ? "nixos",
  }: {
    # NOTE: to be overridden
    hostname = null;
    sshOpts = ["-p" "22"];
    sshUser = "taki";
    user = "root";
    interactiveSudo = true;
    autoRollback = true;
    magicRollback = true;
    remoteBuild = false;
    profiles.system = {
      user = "root";
      path = inputs.deploy-rs.lib.${system}.activate.${configType} self."${configType}Configurations".${hostname};
    };
  };
in {
  flake = {
    nixosConfigurations =
      lib.flip lib.pipe
      [
        (builtins.mapAttrs mkNixosHost)
      ]
      {
        wired = {
          system = "x86_64-linux";
        };
        cyberia = {
          system = "x86_64-linux";
        };
        eiri = {
          system = "x86_64-linux";
        };
        knights = {
          system = "x86_64-linux";
        };
        morpheus = {
          system = "aarch64-linux";
        };
        psyche = {
          system = "x86_64-linux";
          # home-manager = false;
        };
        duvet = {
          system = "x86_64-linux";
        };
        octo = {
          system = "aarch64-linux";
        };
      };

    darwinConfigurations =
      lib.flip lib.pipe
      [
        (builtins.mapAttrs mkNixDarwinHost)
      ]
      {
        arisu = {
          system = "aarch64-darwin";
        };
      };

    deploy.nodes =
      lib.flip lib.pipe
      [
        (lib.concatMapAttrs
          (configType: hosts:
            builtins.mapAttrs
              (hostname: settings:
                mkDeployNode {
                  inherit hostname;
                  inherit (self."${configType}Configurations".${hostname}.pkgs) system;
                  inherit configType;
                }
                // settings)
              hosts))
      ]
      {
        nixos = {
          eiri = {
            # should change this to 10.0.0.1 someday, when i have wg on cyberia
            # but how do I deploy from wired
            hostname = "${allSecrets.per_host.eiri.int_ip}";
          };
          knights = {
            hostname = "${allSecrets.per_host.knights.pub_ip}";
            sshOpts = ["-p" "2202"];
          };
          octo = {
            # temporarily ?
            hostname = "${allSecrets.per_host.octo.int_ip}";
            # important, weak device
            remoteBuild = false;
          };
          duvet = {
            hostname = "${allSecrets.per_host.duvet.pub_ip}";
            sshOpts = ["-p" "2202"];
          };
          cyberia = {
            hostname = "${allSecrets.per_host.cyberia.int_ip}";
            # sshOpts = [ "-p" "2202" ];
          };
        };
        darwin = {
          arisu = {
            hostname = "${allSecrets.per_host.arisu.int_ip}";
            remoteBuild = true;
            user = "taki";
          };
        };
      };
  };
}
