{ lib, config, self, inputs, withSystem, ... }:

{
  imports = [
    inputs.agenix-rekey.flakeModule
  ];

  perSystem = { self', lib, pkgs, system, inputs', ... }: {
    agenix-rekey.nodes = {
      inherit (self.nixosConfigurations)
        wired
        cyberia
        knights
        duvet
        eiri;
    };
  };
}
