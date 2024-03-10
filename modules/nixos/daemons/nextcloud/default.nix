{ config, pkgs, inputs, outputs, ... }:
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    hostName = "files.example.com";
    configureRedis = true;
    config = {
      adminpassFile = "/tmp/nextcloud_adminpass_secret";
    };
  };

  environment.systemPackages = [ pkgs.nextcloud28 ];
}
