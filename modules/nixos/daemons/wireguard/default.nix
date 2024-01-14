{ inputs, outputs, config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  # NOTE: keygen
  # umask 077
  # wg genkey > key
  # wg pubkey < key > key.pub

  # networking.firewall.allowedUDPPorts = [];
  systemd.network = {
    netdevs = {
      "50-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
          MTUBytes = "1300";
        };
        wireguardConfig = {
          PrivateKeyFile = "/home/taki/wg_private_key_secrest";
          ListenPort = 51820;
        };
        wireguardPeers = {
          lib.mapAttrsToList
            (host: peerConfig: {
              wireguardPeerConfig = peerConfig;
            })
            {
              SERN = {
                PublicKey = "QACsJg17ScDNt/fvV3WvBnGYZ7+YFaiIfamznBfE7Rw="
                AllowedIPs = [
                  "10.100.0.2/24"
                  "0.0.0.0/0"
                ];
              };
            };
        };
      };
    };
    networks.wg0 = {
      matchConfig.Name = "wg0";
      address = ["10.100.0.1/24"];
      networkConfig = {
        IPMasquerade = "ipv4";
        IPForward = true;
      };
    };
  };
}
