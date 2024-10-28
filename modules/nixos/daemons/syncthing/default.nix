{ inputs, outputs, config, lib, pkgs, ... }:
{
  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
    dataDir = "/mnt/btrfs_pool/syncthing_data";
    openDefaultPorts = true;
    settings = {
      options = {
        relaysEnabled = true;
        urAccepted = -1;
      };
    };
  };
}
