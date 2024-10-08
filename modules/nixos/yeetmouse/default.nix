{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
{ 
  imports = [
    inputs.yeetmouse.nixosModules.default
  ];
  options.hardware.yeetmouse.enable = true;
}
