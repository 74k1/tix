{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  age.secrets."wireguard_private_key" = {
    rekeyFile = "${inputs.self}/secrets/wireguard_private_key.age";
    mode = "640";
    owner = "systemd-network";
    group = "systemd-network";
  };

  networking = {
    nat = {
      enable = true;
      externalInterface = "enp0s31f6";
      internalInterfaces = [ "wg0" ];
    };
    firewall.allowedUDPPorts = [ 51820 ];
    useNetworkd = true;
  };

  systemd.network = {
    enable = true;

    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      address = [ "10.100.0.1/24" ];
      networkConfig.IPv4Forwarding = true;
      networkConfig.IPv6Forwarding = true;
    };

    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };

      wireguardConfig = {
        ListenPort = 51820;

        PrivateKeyFile = config.age.secrets."wireguard_private_key".path;

        # Automatically create routes for everything in AllowedIPs
        RouteTable = "main";

        # FirewallMark marks all packets send and received by wg0 with the number 42
        # to define policy rules on these packets
        FirewallMark = 42;
      };

      wireguardPeers = [
        {
          # knights
          PublicKey = "dVVhzsUPOT4ln5v4agYw/MxhIb8frEp74oSEIIadgH0=";
          AllowedIPs = [
            "10.100.0.2/32"
          ];
        }
        {
          # duvet
          PublicKey = "p37Qi3vKbl9bnDJC/S1I6ezz2CizSYHDBREnjns5wCQ=";
          AllowedIPs = [
            "10.100.0.3/32"
          ];
        }
      ];
    };
  };
}
