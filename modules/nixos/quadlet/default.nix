{ inputs, outputs, config, lib, pkgs, ... }:
{
  imports = [
    inputs.quadlet.nixosModules.quadlet
  ];

  environment.systemPackages = [
    pkgs.podman
  ];

  virtualisation.quadlet = {
    networks."podman-bridge".networkConfig = {
      driver = "bridge";
      dns = [ "9.9.9.9" "149.112.112.112" ];
    };
    # pods.servarr = {};
  };

  users.users.taki.extraGroups = [ "podman" ];
}
