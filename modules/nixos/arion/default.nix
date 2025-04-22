{ inputs, outputs, config, lib, pkgs, ... }:
{
  imports = [
    inputs.arion.nixosModules.arion
  ];

  environment.systemPackages = [
    pkgs.arion
    pkgs.docker-client
  ];

  virtualisation = {
    docker.enable = true; #lib.mkForce true;
    # podman = {
    #   enable = true;
    #   dockerSocket.enable = true;
    #   defaultNetwork.settings.dns_enabled = true;
    # };
  };

  users.users.taki.extraGroups = [ "docker" "podman" ];
}
