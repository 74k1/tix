{ config, inputs, pkgs, self, ... }:
let
  # Vars
  sitename = "local";
  docroot = "/var/www/";
  domainname = "localhost";
in {
  services.nginx = {
    virtualHosts = {
      localhost = {
        root = "/home/taki/www/localhost";
      };
    };
  };
  services.phpfm.pools = {
    localhost = {
      user = "nginx";
      settings = {
        "listen.owner" = config.services.nginx.user;
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.max_requests" = 500;
        "pm.start_servers" = 2;
      };
    };
  };
}
