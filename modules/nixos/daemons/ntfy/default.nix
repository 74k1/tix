{
  config,
  pkgs,
  inputs,
  outputs,
  allSecrets,
  ...
}:
{
  age.secrets."ntfy_env" = {
    rekeyFile = "${inputs.self}/secrets/ntfy_env.age";
    # mode = "770";
    # owner = "nextcloud";
    # group = "nextcloud";
  };

  # services.redis.servers.nextcloud = {
  #   enable = true;
  #   user = "nextcloud";
  # };

  # services.nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [
  #   {
  #     addr = "0.0.0.0";
  #     port = 801;
  #   }
  # ];

  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://ntfy.${allSecrets.global.domain00}/";
      listen-http = ":9999";
      behind-proxy = true;
      message-size-limit = "4096";
      keepalive-interval = "45s";

      # Login
      auth-default-access = "deny-all";
      enable-login = true;
      enable-signup = false;
      enable-reservations = true;
      require-login = true;
      auth-access = [ "*:up*:write-only" ];

      # Attachments
      attachment-cache-dir = "/var/cache/ntfy-sh";
      attachment-file-size-limit = "20M";
      attachment-total-size-limit = "10G";
      attachment-expiry-duration = "4h";
      cache-file = "/var/lib/ntfy-sh/cache.db";
      cache-duration = "24h";

      # Web push (public key is safe in the store; private key via env below).
      # web-push-public-key = "";
      # web-push-file = "/var/lib/ntfy-sh/webpush.db";
      # web-push-email-address = "";

      # Outgoing email notifications via Fastmail — same submission host +
      # account as authelia; user/pass injected via the EnvironmentFile.
      # smtp-sender-addr = "smtp.fastmail.com:587";
      # smtp-sender-from = "noreply+ntfy@kclj.io";
    };

    # NTFY_AUTH_FILE='/var/lib/ntfy/user.db'
    # NTFY_AUTH_USERS='phil:$2a$10$YLiO8U21sX1uhZamTLJXHuxgVC0Z/GKISibrKCLohPgtG7yIxSk4C:admin,ben:$2a$10$NKbrNb7HPMjtQXWJ0f1pouw03LDLT/WzlO9VAv44x84bRCkh19h6m:user'
    # NTFY_
    environmentFile = config.age.secrets."ntfy_env".path;
  };

  # Attachment blobs live in a CacheDirectory the module doesn't declare.
  systemd.services.ntfy-sh.serviceConfig.CacheDirectory = "ntfy-sh";

  environment.systemPackages = [ pkgs.ntfy-sh ];
}
