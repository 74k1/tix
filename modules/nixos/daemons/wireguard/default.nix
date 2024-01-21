{ inputs, outputs, config, lib, pkgs, ... }:
{
  services.dnsmasq.enable = true;
  services.dnsmasq.extraConfig = ''
    interface=wg0
  '';
  networking = {
    nat = {
      enable = true;
      externalInterface = "enp0s31f6";
      internalInterfaces = [ "wg0" ];
    };
    firewall.allowedUDPPorts = [ 53 51820 ];
    firewall.allowedTCPPorts = [ 53 ];
    wg-quick.interfaces = {
      wg0 = {
        address = [ "10.100.0.1/24" ];
        listenPort = 51820;
        
        postUp = ''
          ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp0s31f6 -j MASQUERADE
        '';

        postDown = ''
          ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.1/24 -o eth0 -j MASQUERADE
        '';

        privateKeyFile = "/home/taki/wg_private_key_secrets";

        peers = [
          { # SERN
            publicKey = "QACsJg17ScDNt/fvV3WvBnGYZ7+YFaiIfamznBfE7Rw=";
            allowedIPs = [
              "10.100.0.2/24"
              "0.0.0.0/0"
              "::/0"
            ];
          }
          { # MAGI
            publicKey = "JOf290ilGAOw2msc6aQsE+oSjvLA1g9Cvw6RvmsTJj4=";
            allowedIPs = [
              "10.100.0.3/24"
              "0.0.0.0/0"
              "::/0"
            ];
          }
          { # NERV
            publicKey = "vnmW4+i/tKuiUx86JGOax3wHl1eAPwZj+/diVkpiZgM=";
            allowedIPs = [
              "10.100.0.4/24"
              "0.0.0.0/0"
              "::/0"
            ];
          }
        ];
      };
    };
  };
}
