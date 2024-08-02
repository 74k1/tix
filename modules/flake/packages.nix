{ lib, config, self, inputs, withSystem, ... }:

{
  perSystem = { self, lib, pkgs, system, inputs', ... }: {
    packages = import ../pkgs { inherit pkgs; };
  };
}
