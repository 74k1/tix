{ lib, config, self, inputs, withSystem, ... }:

{
  perSystem = { self, lib, pkgs, system, inputs', ... }: {
    packages = import "${inputs.self}/pkgs" { inherit pkgs; };
  };
}
