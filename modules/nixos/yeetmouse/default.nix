{
  inputs,
  outputs,
  system,
  config,
  lib,
  pkgs,
  ...
}:
{ 
  imports = [
    inputs.yeetmouse.nixosModules.default
  ];
  environment.systemPackages = [
    inputs.yeetmouse.packages."${system}".default
  ];
}
