{ lib, config, self, inputs, withSystem, ... }:

let
  outputs = self;

  mkNixosHost = hostname: { system, home-manager ? true }: lib.nixosSystem {
    inherit system;
    modules = [
      # Main config
      "${inputs.self}/hosts/nixos/${hostname}/configuration.nix"
      # nix-topology
      inputs.nix-topology.nixosModules.default
    ] ++ lib.optionals home-manager [
      # Home Manager
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = false;
          useUserPackages = true;
          users.taki = import "${inputs.self}/hosts/nixos/${hostname}/home.nix";
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

  mkDeployNode = { hostname, system }: {
    # NOTE: to be overridden
    hostname = null;
    sshOpts = [ "-p" "22" ];
    sshUser = "taki";
    user = "root";
    interactiveSudo = true;
    autoRollback = true;
    magicRollback = true;
    remoteBuild = false;
    profiles.system = {
      user = "root";
      path = inputs.deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.${hostname};
    };
  };
in
{
  flake = {
    nixosConfigurations = lib.flip lib.pipe
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
          home-manager = false;
        };
      };

    deploy.nodes = lib.flip lib.pipe
      [
        (builtins.mapAttrs
          (hostname: settings:
            mkDeployNode {
              inherit hostname;
              inherit (self.nixosConfigurations.${hostname}.pkgs) system;
            } // settings))
      ]
      {
        eiri = {
          # should change this to 10.0.0.1 someday, when i have wg on cyberia
          hostname = "255.255.255.255";
        };
        knights = {
          hostname = "10.100.0.2";
          sshOpts = [ "-p" "2202" ];
        };
        morpheus = {
          # temporarily
          hostname = "192.168.1.61";
          # important, weak device
          remoteBuild = false;
        };
      };
  };
}
