{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  allSecrets,
  ...
}: {
  services.rustdesk-server = {
    enable = true;
    relay = {
      enable = true;
    };
    signal = {
      enable = true;
      relayHosts = ["${allSecrets.per_host.eiri.int_ip}" "rd.eiri.74k1.sh"];
    };
  };
}
