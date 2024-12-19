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
    ../vpnconfinement
  ];

  vpnNamespaces.proton = {
    portMappings = [
      {
        from = 9091;
        to = 9091;
      }
    ];
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
      port-forwarding-enabled = false;
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
    vpnnamespace = "proton";
  };

  # systemd.services.transmission-proton-port-forward = {
  #   description = "ProtonVPN Port Forwarding for Transmission";
  #   after = ["network-online.target" "proton.service" "transmission.service"];
  #   requires = ["proton.service" "transmission.service"];
  #   wantedBy = ["multi-user.target"];
  #
  #   vpnconfinement = {
  #     enable = true;
  #     vpnnamespace = "proton";
  #   };
  #
  #   script = ''
  #     while true; do
  #       ${pkgs.libnatpmp}/bin/natpmpc -g 10.2.0.1 -a 60729 0 tcp 60
  #       ${pkgs.libnatpmp}/bin/natpmpc -g 10.2.0.1 -a 60729 0 udp 60
  #       sleep 45
  #     done
  #   '';
  # };
}
