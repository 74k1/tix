{ inputs, outputs, config, pkgs, ... }:
{
  services.ollama = {
    enable = true;
    host = "127.0.0.1";
    port = 11434;
    acceleration = "cuda";
    models = "/mnt/btrfs_pool/ollama_models";
    environmentVariables = {
      OLLAMA_ORIGINS = "*";
    };
  };

  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    port = 3335;
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      TRANSFORMERS_CACHE = "${config.services.open-webui.stateDir}/cache";
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
      # Disable authentication
      WEBUI_AUTH = "False";
    };
    openFirewall = true;
  };
}
