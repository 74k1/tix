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
    # mode = "770";
    # owner = "xyz";
    # group = "xyz";
  };

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

        peers = [
          {
            # knights
            publicKey = "dVVhzsUPOT4ln5v4agYw/MxhIb8frEp74oSEIIadgH0=";
            allowedIPs = [
              "10.100.0.2/32"
            ];
          }
          {
            # duvet
            publicKey = "PTH6K+9jQgVfa7zB9CYoCC8abQ6kM2ioWElycyN0Ky4=";
            allowedIPs = [
              "10.100.0.3/32"
            ];
          }
        ];
      };
    };
  };
}
