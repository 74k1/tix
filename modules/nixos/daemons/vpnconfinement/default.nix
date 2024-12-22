{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  age.secrets."proton_slskd" = {
    rekeyFile = "${inputs.self}/secrets/proton_slskd.age";
    name = "prsl.conf";
  };

  age.secrets."proton_transmission" = {
    rekeyFile = "${inputs.self}/secrets/proton_transmission.age";
    name = "prtr.conf";
  };

  vpnNamespaces = { 
    prsl = {
      enable = true;
      wireguardConfigFile = config.age.secrets."proton_slskd".path;
      namespaceAddress = "192.168.15.1";
      bridgeAddress = "192.168.15.5";

      accessibleFrom = [
        "192.168.0.0/16"
        # "10.0.0.0/24"
        "127.0.0.1/32"
      ];
    };
    prtr = {
      enable = true;
      wireguardConfigFile = config.age.secrets."proton_transmission".path;
      namespaceAddress = "192.168.11.1";
      bridgeAddress = "192.168.11.5";

      accessibleFrom = [
        "192.168.0.0/16"
        # "10.0.0.0/24"
        "127.0.0.1/32"
      ];
    };
  };
}
