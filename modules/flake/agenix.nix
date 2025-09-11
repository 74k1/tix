{
  lib,
  config,
  self,
  inputs,
  withSystem,
  ...
}:

{
  imports = [
    inputs.agenix-rekey.flakeModule
  ];

  perSystem =
    {
      self',
      lib,
      pkgs,
      system,
      inputs',
      ...
    }:
    {
      agenix-rekey.nodes = {
        inherit (self.nixosConfigurations)
          duvet
          eiri
          knights
          ;
      };
      agenix-rekey.homeConfigurations = { };
    };
}
