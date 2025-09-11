{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  allSecrets,
  ...
}:
{
  age.secrets."karakeep_secret" = {
    rekeyFile = "${inputs.self}/secrets/karakeep_secret.age";
    # mode = "770";
    # owner = "";
    # group = "";
  };

  services = {
    karakeep = {
      enable = true;
      extraEnvironment = {
        # NEXTAUTH_URL = "karakeep.eiri.${allSecrets.global.domain01}";
        PORT = "3400";
        DISABLE_NEW_RELEASE_CHECK = "false";
        DISABLE_SIGNUPS = "true";
        ASSETS_DIR = "/mnt/btrfs_pool/karakeep/";
        MAX_ASSET_SIZE_MB = "2048";
        INFERENCE_ENABLE_AUTO_SUMMARIZATION = "true";
        INFERENCE_JOB_TIMEOUT_SEC = "120";
        # Crawler settings
        CRAWLER_STORE_SCREENSHOT = "true";
        CRAWLER_FULL_PAGE_SCREENSHOT = "true";
        CRAWLER_FULL_PAGE_ARCHIVE = "true";
        CRAWLER_VIDEO_DOWNLOAD = "true";
        CRAWLER_VIDEO_DOWNLOAD_MAX_SIZE = "2048";
        CRAWLER_ENABLE_ADBLOCKER = "true";
      };
      # Required:
      # NEXTAUTH_SECRET
      # OLLAMA_BASE_URL
      # OLLAMA_KEEP_ALIVE
      environmentFile = config.age.secrets."karakeep_secret".path;
    };
  };
}
