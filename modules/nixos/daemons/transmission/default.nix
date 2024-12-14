{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  # self,
  ...
}: {
  imports = [
    (toString ../vpnconfinement)
    # self.nixosModules.vpnconfinement
    # "${self}/modules/nixos/daemons/vpnconfinement"
  ];

  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    webHome = pkgs.flood-for-transmission;
    openRPCPort = true;
    settings = {
      blocklist-enabled = false;
      blocklist-url = "https://github.com/Naunter/BT_BlockLists/raw/master/bt_blocklists.gz";
      download-dir = "/mnt/btrfs_pool/torrents/download";
      download-queue-enabled = false;
      download-queue-size = 5;
      encryption = 1;
      idle-seeding-limit = 30; # minutes
      idle-seeding-limit-enabled = false;
      incomplete-dir = "/mnt/btrfs_pool/torrents/incomplete";
      incomplete-dir-enabled = true;
      peer-limit-global = 10000;
      peer-limit-per-torrent = 500;
      peer-port = 60729;
      peer-port-random-on-start = false;
      port-forwarding-enabled = true;
      lpd-enabled = true;
      ratio-limit = 10;
      ratio-limit-enabled = true;
      rename-partial-files = true;
      rpc-bind-address = "0.0.0.0";
      rpc-password = "00000000";
      rpc-port = 9091;
      rpc-username = "taki";
      rpc-whitelist = "127.0.0.1,192.168.*.*";
      start-added-torrents = true;
    };
  };

  systemd.services.transmission.vpnconfinement = {
    enable = true;
    vpnnamespace = "mu";
  };
}
