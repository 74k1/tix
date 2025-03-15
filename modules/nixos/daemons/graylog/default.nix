{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  # send logs to 255.255.255.255:1515 :)
  services = {
    graylog = {
      enable = true;
      extraConfig = ''
        http_bind_address = 0.0.0.0:9000
      '';
      elasticsearchHosts = [ "http://127.0.0.1:9200" ];
      passwordSecret = "00000000"; # pwgen -N 1 -s 96
      rootPasswordSha2 = "00000000";
    };
    mongodb = {
      enable = true;
    };
    opensearch = {
      enable = true;
      settings = {
        "cluster.name" = "graylog";
      };
    };
  };
}
