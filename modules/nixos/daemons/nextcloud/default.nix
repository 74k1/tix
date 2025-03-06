{ config, pkgs, inputs, outputs, ... }:
{
  age.secrets."nextcloud_admin" = {
    rekeyFile = "${inputs.self}/secrets/nextcloud_admin.age";
    mode = "770";
    owner = "nextcloud";
    group = "nextcloud";
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    # extraApps = {
    #   inherit (config.services.nextcloud.package.packages.apps) contacts calendar onlyoffice;
    # };
    extraAppsEnable = true;
    hostName = "files.example.com";
    home = "/mnt/btrfs_pool/nextcloud_data";
    configureRedis = true;
    autoUpdateApps.enable = true;
    maxUploadSize = "100G";
    fastcgiTimeout = 360;
    config = {
      # adminpassFile = "/tmp/nextcloud_adminpass_secret";
      adminpassFile = config.age.secrets."nextcloud_admin".path;
      dbtype = "sqlite";
    };
    nginx.hstsMaxAge = 15552000;
    phpOptions = {
      "max_execution_time" = "600";
      "max_input_time" = "600";
      "default_socket_timeout" = "360";
      "opcache.fast_shutdown" = "1";
      "opcache.interned_strings_buffer" = "8";
      "opcache.max_accelerated_files" = "10000";
      "opcache.memory_consumption" = "128";
      "opcache.revalidate_freq" = "1";
    };
    settings = {
      trusted_proxies = [ "10.100.0.2" ];
      overwriteprotocol = "https";
      log_type = "file";
      enabledPreviewProviders = [
        "OC\\Preview\\BMP"
        "OC\\Preview\\GIF"
        "OC\\Preview\\JPEG"
        "OC\\Preview\\Krita"
        "OC\\Preview\\MarkDown"
        "OC\\Preview\\MP3"
        "OC\\Preview\\OpenDocument"
        "OC\\Preview\\PNG"
        "OC\\Preview\\TXT"
        "OC\\Preview\\XBitmap"
        "OC\\Preview\\HEIC"
      ];
    };
  };

  environment.systemPackages = [ pkgs.nextcloud31 ];
}
