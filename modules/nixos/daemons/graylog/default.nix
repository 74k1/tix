{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  allSecrets,
  ...
}:
{
  # send logs to ${allSecrets.per_host.eiri.int_ip}:1515 :)
  services = {
    graylog = {
      enable = true;
      package = pkgs.graylog-6_0;
      extraConfig = ''
        http_bind_address = 0.0.0.0:9000
      '';
      elasticsearchHosts = [ "http://127.0.0.1:9100" ];
      passwordSecret = "${allSecrets.per_service.graylog.passwordSecret}"; # pwgen -N 1 -s 96
      rootPasswordSha2 = "${allSecrets.per_service.graylog.rootPasswordSha2}";
    };
    # mongodb = {
    #   enable = true;
    # };
    opensearch = {
      enable = true;
      settings = {
        "cluster.name" = "graylog";
        "http.port" = 9100;
      };
    };
  };
}
