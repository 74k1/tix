{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  age.secrets."proton_config" = {
    rekeyFile = "${inputs.self}/secrets/proton_config.age";
    name = "proton.conf";
  };

  vpnNamespaces.proton = {
    enable = true;
    wireguardConfigFile = config.age.secrets."proton_config".path;
    namespaceAddress = "192.168.11.1";
    bridgeAddress = "192.168.11.5";

    accessibleFrom = [
      "192.168.0.0/16"
      # "10.0.0.0/24"
      "127.0.0.1/32"
    ];
  };
}
