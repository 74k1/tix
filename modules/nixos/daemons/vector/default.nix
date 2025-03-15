{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  # age.secrets."paperless_pass" = {
  #   rekeyFile = "${inputs.self}/secrets/paperless_pass.age";
  #   # mode = "770";
  #   # owner = "nextcloud";
  #   # group = "nextcloud";
  # };
  services.vector = {
    enable = true;
    # passwordFile = config.age.secrets."paperless_pass".path;
    journaldAccess = true;
    settings = {
      api.enabled = false;
      sources.journald = {
        type = "journald";
        exclude_matches.SYSLOG_IDENTIFIER = [ "kernel" ];
      };
      sinks.graylog_gelf = {
        type = "gelf_tcp";
        inputs = [ "journald" ];
        host = "10.0.0.1";
        port = 1515;
      };
    };
  };
}
