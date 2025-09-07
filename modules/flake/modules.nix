{
  lib,
  config,
  self,
  inputs,
  withSystem,
  ...
}:

{
  flake = {
    nixosModules = import "${inputs.self}/modules/nixos";

    darwinModules = import "${inputs.self}/modules/darwin";

    homeManagerModules = import "${inputs.self}/modules/home-manager";
  };
}
