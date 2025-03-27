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
      package = pkgs.graylog-6_0;
      extraConfig = ''
        http_bind_address = 0.0.0.0:9000
      '';
      elasticsearchHosts = [ "http://127.0.0.1:9200" ];
      passwordSecret = "00000000"; # pwgen -N 1 -s 96 # TODO
      rootPasswordSha2 = "00000000"; # TODO
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
