{ config, lib, pkgs, ... }:
{
  services.immich = {
    enable = true;
    host = "0.0.0.0";
    port = 2870;
    mediaLocation = "/mnt/btrfs_pool/immich/";
    openFirewall = true;
    secretsFile = "/home/taki/immich_secret";
  };
}
