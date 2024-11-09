
{ lib, config, self, inputs, ... }:

{
  imports = [
    inputs.nix-topology.flakeModule
  ];

  perSystem = { lib, pkgs, self', system, ... }: {
    topology = {
      nixosConfigurations = self.nixosConfigurations;
      modules = [
        {
        }
      ];
    };
  };
}
