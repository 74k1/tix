{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.ouro.nixosModules.default
  ];

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

      ouro = {
        enable = true;
        gateway = "10.2.0.1";
        interface = "prsl0";
        slskd.enable = true;
      };
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

      ouro = {
        enable = true;
        gateway = "10.2.0.1";
        interface = "prtr0";

        transmission = {
          enable = true;
          # rpc_file = ./yee.age ; # file path with ENV vars perhaps
          RPC_USER="taki";
          RPC_PASS="00000000";
        };
      };
    };
  };
}
