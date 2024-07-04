{ config, lib, pkgs, ... }:
{
  # virtualisation.arion = {
  #   backend = "docker";
  #   projects."immich-redis".settings.services."immich-redis".service = {
  #     image = "redis:alpine";
  #     restart = "unless-stopped";
  #     #command = "redis-server --save 20 1 --loglevel warning --requirepass oFSQJrEnHq2FoDz7W7Fp";
  #     volumes = [
  #       "/var/lib/send-redis/:/data"
  #       "/etc/localtime:/etc/localtime:ro"
  #     ];
  #     ports = [
  #       "6379:6379"
  #     ];
  #   };
  # };
}
