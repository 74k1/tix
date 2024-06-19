{ config, lib, pkgs, ... }:
{
  # networking.wg-quick.interfaces = {
  #   wg1 = {
  #     address = [ "10.66.155.50/32" "fc00:bbbb:bbbb:bb01::3:9b31/128" ];
  #     dns = [ "10.64.0.1" "192.168.1.1" ];
  #     privateKeyFile = "/home/taki/mullvad_private_key_secret";
  #     peers = [
  #       {
  #         publicKey = "5Ms10UxGjCSzwImTrvEjcygsWY8AfMIdYyRvgFuTqH8=";
  #         allowedIPs = [ "0.0.0.0/0" "::0/0" ];
  #         endpoint = "193.32.127.68:51820";
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };

  services = {
    # Indexer
    prowlarr.enable = true;

    # Music
    lidarr.enable = true;

    # Movies
    radarr.enable = true;

    # TV
    sonarr.enable = true;

    # # Transmission
    # transmission = {
    #   enable = true;
    #   openRPCPort = true;
    #   settings = { 
    #     download-dir = "/mnt/btrfs_pool/torrents/download";
    #     incomplete-dir = "/mnt/btrfs_pool/torrents/incomplete";
    #     incomplete-dir-enabled = true;
    #     rpc-bind-address = "0.0.0.0";
    #     rpc-port = 9092;
    #     rpc-whitelist = "192.168.1.*,10.100.0.*";
    #     rpc-username = "taki";
    #     rpc-password = "00000000";
    #   };
    # };
  };

  virtualisation.arion = {
    backend = "docker";
    projects = {
      "flaresolverr".settings.services."flaresolverr".service = {
        image = "ghcr.io/flaresolverr/flaresolverr:latest";
        restart = "unless-stopped";
        environment = {
          LOG_LEVEL = ''''${LOG_LEVEL:-info}'';
          LOG_HTML = ''''${LOG_HTML:-false}'';
          CAPTCHA_SOLVER = ''''${CAPTCHA_SOLVER:-none}'';
          TZ = "Europe/Zurich";
        };
        ports = [
          ''''${PORT:-8191}:8191''
        ];
      };
    };
  };
}
