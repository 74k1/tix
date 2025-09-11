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
  age.secrets = {
    "meilisearch_master_key" = {
      rekeyFile = "${inputs.self}/secrets/meilisearch_master_key.age";
    };
    "karakeep_env" = {
      rekeyFile = "${inputs.self}/secrets/karakeep_env.age";
    };
  };

  services = {
    meilisearch = {
      # enable = true;
      masterKeyFile = config.age.secrets."meilisearch_master_key".path;
    };

    karakeep = {
      enable = true;
      meilisearch = {
        enable = true;
        experimental_dumpless_upgrade = true;
      };
      extraEnvironment = {
        # https://docs.karakeep.app/configuration/environment-variables
        # Required
        NEXTAUTH_URL = "https://bookmark.${allSecrets.global.domain00}";

        PORT = "3400";
        DISABLE_NEW_RELEASE_CHECK = "false";

        ASSETS_DIR = "/mnt/btrfs_pool/karakeep/";
        MAX_ASSET_SIZE_MB = "4096";

        # Crawler settings
        CRAWLER_STORE_SCREENSHOT = "true";
        CRAWLER_FULL_PAGE_SCREENSHOT = "true";
        CRAWLER_FULL_PAGE_ARCHIVE = "true";
        CRAWLER_VIDEO_DOWNLOAD = "true";
        CRAWLER_VIDEO_DOWNLOAD_MAX_SIZE = "2048";
        CRAWLER_ENABLE_ADBLOCKER = "true";

        # AUTH / OIDC
        DISABLE_SIGNUPS = "true";
        DISABLE_PASSWORD_AUTH = "true";
        OAUTH_AUTO_REDIRECT = "true";
        OAUTH_WELLKNOWN_URL = allSecrets.global.oidc.discoveryUrl;
        OAUTH_PROVIDER_NAME = "Pocket ID";

        # OLLAMA
        OLLAMA_KEEP_ALIVE = "5m";
        OLLAMA_BASE_URL = "http://192.168.1.108:11434/v1";
        INFERENCE_TEXT_MODEL = "qwen3.6:35b";
        INFERENCE_IMAGE_MODEL = "qwen3.6:35b";
        EMBEDDING_TEXT_MODEL = "qwen3.6:35b";
        INFERENCE_CONTEXT_LENGTH = "256000";
        INFERENCE_MAX_OUTPUT_TOKENS = "48000";
        INFERENCE_ENABLE_AUTO_TAGGING = "true";
        INFERENCE_ENABLE_AUTO_SUMMARIZATION = "true";
        INFERENCE_JOB_TIMEOUT_SEC = "300";
        INFERENCE_FETCH_TIMEOUT_SEC = "600";
      };
      # Required:
      # NEXTAUTH_SECRET
      # MEILI_MASTER_KEY
      # OAUTH_CLIENT_ID
      # OAUTH_CLIENT_SECRET
      environmentFile = config.age.secrets."karakeep_env".path;
    };
  };
}
