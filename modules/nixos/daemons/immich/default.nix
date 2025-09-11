{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  services.immich = {
    enable = true;
    package = pkgs.immich;
    mediaLocation = "/mnt/btrfs_pool/immich_media/";
    host = "0.0.0.0";
    port = 3001;
    machine-learning.enable = true;
  };
}
