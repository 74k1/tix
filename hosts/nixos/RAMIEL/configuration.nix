{ inputs, outputs, lib, config, pkgs, ... }:

{
  imports = with outputs.nixosModules; [
    ./hardware-configuration.nix
  ];
}
