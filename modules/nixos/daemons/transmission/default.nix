{ inputs, outputs, config, lib, pkgs, ... }:
{
  age.secrets."mullvad_config" = {
    # btw, new nix treesitter indent queries, i/e. indenting is now reasonable
    rekeyFile = "${inputs.self}/secrets/mullvad_config.age";
    name = "mu.conf";
    # mode = "770";
    # owner = "nextcloud";
    # group = "nextcloud";
  };

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
  
  vpnnamespaces.mu = {
    enable = true;
    # wireguardConfigFile = /tmp/mu.conf;
    wireguardConfigFile = config.age.secrets."mullvad_config".path;
    namespaceAddress = "192.168.11.1";
    bridgeAddress = "192.168.11.5";
    accessibleFrom = [
      "192.168.0.0/16"
      "10.0.0.0/24"
      "127.0.0.1/32"
    ];
    portMappings = [
      { from = 9091; to = 9091; }
      { from = 60729; to = 60729; protocol = "both"; }
    ];
    openVPNPorts = [{
      port = 60729;
      protocol = "both";
    }];
  };
  
  systemd.services.transmission.vpnconfinement = {
    enable = true;
    vpnnamespace = "mu";
  };
}
