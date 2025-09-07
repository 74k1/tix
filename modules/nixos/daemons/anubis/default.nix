{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  services.anubis.defaultOptions.settings = {
    DIFFICULTY = 4;
    OG_CACHE_CONSIDER_HOST = true;
    OG_PASSTHROUGH = true;
    SERVE_ROBOTS_TXT = true;
    # WEBMASTER_EMAIL = "";
  };
}
