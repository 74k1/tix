{ inputs, outputs, config, lib, pkgs, ... }:
{
  age.secrets."wireguard_private_key" = {
    rekeyFile = "${inputs.self}/secrets/wireguard_private_key.age";
    # mode = "770";
    # owner = "nextcloud";
    # group = "nextcloud";
  };

  # if internet problems occur, check ip route lol
  # sudo ip route del default dev wg0
  # ^ this should do the trick.
  networking = {
    nat = {
      enable = true;
      externalInterface = "enp0s31f6";
      internalInterfaces = [ "wg0" ];
    };
    firewall.allowedUDPPorts = [ 51820 ];
    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.100.0.1/24" ];
        listenPort = 51820;

        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp0s31f6 -j MASQUERADE
        '';

        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enp0s31f6 -j MASQUERADE
        '';

        # privateKeyFile = "/home/taki/wg_private_key_secrets";
        privateKeyFile = config.age.secrets."wireguard_private_key".path;

        peers = [ # TODO
          { # knights / proxy
            publicKey = "dVVhzsUPOT4ln5v4agYw/MxhIb8frEp74oSEIIadgH0=";
            allowedIPs = [
              "10.100.0.2/32"
            ];
          }
          { # cyberia
            publicKey = "eR6y0rHuhb+qhBaZWWigQnjHjZ1m4oRJzYVPrv3CgBM=";
            allowedIPs = [
              "10.100.0.10/32"
            ];
          }
          { # MAGI
            publicKey = "JOf290ilGAOw2msc6aQsE+oSjvLA1g9Cvw6RvmsTJj4=";
            allowedIPs = [
              "10.100.0.3/32"
            ];
          }
          { # NERV
            publicKey = "vnmW4+i/tKuiUx86JGOax3wHl1eAPwZj+/diVkpiZgM=";
            allowedIPs = [
              "10.100.0.4/32"
            ];
          }
          { # EVA
            publicKey = "qL6QmOPbBx6Ej7HzNE/HwRo4vPts7EbTfIr/QMBIcyw=";
            allowedIPs = [
              "10.100.0.5/32"
            ];
          }
        ];
      };
    };
  };
}
