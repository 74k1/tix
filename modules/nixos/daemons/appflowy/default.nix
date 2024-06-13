{ config, lib, pkgs, ... }:
{
  project.name = "appflowy";
  services = {
    "nginx".service = {
      image = "nginx";
      restart = "on-failure";
      # environment = {};
      ports = [
        ''''${}:9444''
      ];
      volumes = [
        ''''
      ];
    };
  };
}
