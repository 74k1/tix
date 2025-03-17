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
  services.rsyslogd = {
    enable = true;
  };
  services.vector = {
    enable = true;
    # passwordFile = config.age.secrets."paperless_pass".path;
    journaldAccess = true;
    settings = {
      api.enabled = true;
      sources = {
        nginx-syslog = {
          type = "syslog";
          address = "127.0.0.1:9000";
          mode = "udp";
        };
        # journald = {
        #   type = "journald";
        #   exclude_matches.SYSLOG_IDENTIFIER = [ "kernel" ];
        # };
        # file = {
        #   type = "file";
        #   include = [
        #     "/var/log/nginx/access.log"
        #     "/var/log/nginx/error.log"
        #   ];
        # };
        # host_metrics = {
        #   type = "host_metrics";
        # };
      };
      sinks = {
        syslog-graylog = {
          type = "socket";
          inputs = [ "nginx-syslog" ];
          address = "10.100.0.1:1510";
          mode = "udp";
          encoding.codec = "raw_message";
        };
        # graylog = {
        #   type = "http";
        #   inputs = [ "journald" "file" ];
        #   uri = "http://10.0.0.1:1515/";
        #   encoding.codec = "gelf";
        # };
      };
    };
  };
}
