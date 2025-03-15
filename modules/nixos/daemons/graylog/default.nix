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
  services = {
    graylog = {
      enable = true;
      # extraConfig = ''
      #   http_external_uri = https://graylog.example.com/
      # '';
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
