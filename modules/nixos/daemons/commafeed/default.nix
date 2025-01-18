{ inputs, outputs, config, lib, pkgs, ... }:
{
  # age.secrets."commafeed_env" = {
  #   rekeyFile = "${inputs.self}/secrets/commafeed_env.age";
  #   # mode = "770";
  #   # owner = "nextcloud";
  #   # group = "nextcloud";
  # };

  services.commafeed = {
    enable = true;
    # https://github.com/Athou/commafeed/blob/master/commafeed-server/doc/commafeed.md
    environment = {
      # Configuration
      COMMAFEED_HIDE_FROM_WEB_CRAWLERS = true;
      COMMAFEED_PASSWORD_RECOVERY_ENABLED = true;

      # HTTP Client configuration
      COMMAFEED_HTTP_CLIENT_CACHE_MAXIMUM_MEMORY_SIZE = "20M";

      # Feed refresh engine settings
      COMMAFEED_FEED_REFRESH_INTERVAL = "15M";
      COMMAFEED_FEED_REFRESH_INTERVAL_EMPIRICAL = true;

      # Database cleanup settings
      COMMAFEED_DATABASE_CLEANUP_ENTRIES_MAX_AGE = "182D";
      COMMAFEED_DATABASE_CLEANUP_MAX_FEED_CAPACITY = 1000;

      # Users settings
      COMMAFEED_USERS_ALLOW_REGISTRATIONS = true; # temporary, to add new users
    };
    # environmentFile = config.age.secrets."commafeed_env".path;
  };
}
