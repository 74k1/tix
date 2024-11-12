{ lib, config, self, inputs, withSystem, ... }:

{
  perSystem = { self, lib, pkgs, system, inputs', ... }: {
    packages = import "${inputs.self}/pkgs" {
      # NOTE: using a fresh `pkgs` to avoid recursion
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    };
  };
}
