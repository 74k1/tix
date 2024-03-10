{ config, pkgs, inputs, outputs, ... }:
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    hostName = "files.example.com";
    home = "/mnt/btrfs_pool/nextcloud_data";
    configureRedis = true;
    autoUpdateApps.enable = true;
    maxUploadSize = "100G";
    config = {
      adminpassFile = "/tmp/nextcloud_adminpass_secret";
    };
    settings = {
      trusted_proxies = [ "10.100.0.2" ];
      overwriteprotocol = "https";
    };
  };

  environment.systemPackages = [ pkgs.nextcloud28 ];
}
