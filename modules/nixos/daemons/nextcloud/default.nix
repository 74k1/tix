{ config, pkgs, inputs, outputs, allSecrets, ... }:
{
  age.secrets."nextcloud_admin" = {
    rekeyFile = "${inputs.self}/secrets/nextcloud_admin.age";
    mode = "770";
    owner = "nextcloud";
    group = "nextcloud";
  };

  # services.redis.servers.nextcloud = {
  #   enable = true;
  #   user = "nextcloud";
  # };

  services.nextcloud = {
    enable = true;
    package = pkgs.master.nextcloud31;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) unroundedcorners onlyoffice;
    };
    extraAppsEnable = true;
    hostName = "files.${allSecrets.global.domain0}";
    home = "/mnt/btrfs_pool/nextcloud_data";
    configureRedis = true;
    autoUpdateApps.enable = true;
    maxUploadSize = "100G";
    fastcgiTimeout = 86400;
    config = {
      # adminpassFile = "/tmp/nextcloud_adminpass_secret";
      adminpassFile = config.age.secrets."nextcloud_admin".path;
      dbtype = "sqlite";
    };
    nginx.hstsMaxAge = 15552000;
    phpOptions = {
      "max_execution_time" = "600";
      "max_input_time" = "600";
      "request_terminate_timeout" = "600";
      "default_socket_timeout" = "86400";
      "opcache.fast_shutdown" = "1";
      "opcache.interned_strings_buffer" = "8";
      "opcache.max_accelerated_files" = "10000";
      "opcache.memory_consumption" = "128";
      "opcache.revalidate_freq" = "1";
      # "memcache.locking" = "\\OC\\Memcache\\Redis";
      # "memcache.distributed" = "\\OC\\Memcache\\Redis";
      # 504 error handling?
      "php_admin_value[max_input_time]" = "86400";
      "php_admin_value[max_execution_time]" = "86400";
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
      "bulkupload.enabled" = "false";
      maintenance_window_start = "12";
      preview_ffmpeg_path = "${pkgs.ffmpeg-headless}/bin/ffmpeg";
      reduce_to_languages = [ "en" ];
      # redis = {
      #   host = config.services.redis.servers.nextcloud.unixSocket;
      #   port = 0;
      # };
    };
  };

  environment.systemPackages = [ pkgs.nextcloud31 ];
}
