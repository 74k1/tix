{ inputs, outputs, config, lib, pkgs, ... }:
{
  services.transmission = {
    enable = true;
    webHome = pkgs.flood-for-transmission;
    openRPCPort = true;
    settings = { 
      blocklist-enabled = true;
      blocklist-url = "https://github.com/Naunter/BT_BlockLists/raw/master/bt_blocklists.gz";
      download-dir = "/mnt/btrfs_pool/torrents/download";
      encryption = 1;
      incomplete-dir = "/mnt/btrfs_pool/torrents/incomplete";
      incomplete-dir-enabled = true;
      peer-port = 60669;
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
  
  vpnnamespaces.mu = {
    enable = true;
    wireguardConfigFile = /. + "/tmp/mu.conf";
    namespaceAddress = "192.168.11.1";
    bridgeAddress = "192.168.11.5";
    accessibleFrom = [
      "192.168.0.0/16"
      "10.0.0.0/24"
      "127.0.0.1/32"
    ];
    portMappings = [
      { from = 9091; to = 9091; }
    ];
    openVPNPorts = [{
      port = 60669;
      protocol = "both";
    }];
  };
  
  systemd.services.transmission.vpnconfinement = {
    enable = true;
    vpnnamespace = "mu";
  };
}
