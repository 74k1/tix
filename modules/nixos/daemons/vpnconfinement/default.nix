{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}: {
  age.secrets."mullvad_config" = {
    rekeyFile = "${inputs.self}/secrets/mullvad_config.age";
    name = "mu.conf";
    # mode = "770";
    # owner = "mullvad";
    # group = "mullvad";
  };

  vpnNamespaces.mu = {
    enable = true;
    wireguardConfigFile = config.age.secrets."mullvad_config".path;
    namespaceAddress = "192.168.11.1";
    bridgeAddress = "192.168.11.5";
    accessibleFrom = [
      "192.168.0.0/16"
      "10.0.0.0/24"
      "127.0.0.1/32"
    ];
    portMappings = [
      { from = 9091; to = 9091; }
      { from = 60729; to = 60729; protocol = "both"; }
    ];
    openVPNPorts = [{
      port = 60729;
      protocol = "both";
    }];
  };
}
