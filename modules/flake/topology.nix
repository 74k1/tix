{
  lib,
  config,
  self,
  inputs,
  ...
}:

{
  imports = [
    inputs.nix-topology.flakeModule
  ];

  perSystem =
    {
      lib,
      pkgs,
      self',
      system,
      ...
    }:
    {
      # NOTE: make you able to `nix build .#topology`
      legacyPackages = {
        topology = self.topology.${system}.config.output;
      };

      topology = {
        nixosConfigurations = self.nixosConfigurations;
        modules = [
          {
          }
        ];
      };
    };
}
