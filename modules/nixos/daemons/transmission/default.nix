{ inputs, outputs, config, lib, pkgs, ... }:
{
  services.transmission = {
    enable = true;
    webHome = pkgs.flood-for-transmission;
    openRPCPort = true;
    settings = { 
      download-dir = "/mnt/btrfs_pool/torrents/download";
      incomplete-dir = "/mnt/btrfs_pool/torrents/incomplete";
      incomplete-dir-enabled = true;
      rpc-bind-address = "192.168.15.5";
      # rpc-bind-address = "0.0.0.0";
      rpc-port = 9091;
      rpc-username = "taki";
      rpc-password = "00000000";
    };
  };
  
  # https://github.com/Maroka-chan/VPN-Confinement
  vpnnamespaces.mul = {
    enable = true;
    wireguardConfigFile = /. + "/tmp/mul0.conf";
    # namespaceAddress = "192.168.11.1";
    # bridgeAddress = "192.168.11.5";
    accessibleFrom = [
      "192.168.1.0/24"
      "10.0.0.0/24"
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
    vpnnamespace = "mul";
  };
}
