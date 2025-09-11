{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  disabledModules = [ "services/misc/open-webui.nix" ];

  imports = [
    "${inputs.nixpkgs-master}/nixos/modules/services/misc/open-webui.nix"
  ];

  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    port = 3335;
    package = pkgs.master.open-webui;
    environment = {
      HOME = "${config.services.open-webui.stateDir}";
      TRANSFORMERS_CACHE = "${config.services.open-webui.stateDir}/cache";
      STATIC_DIR = "${config.services.open-webui.stateDir}/static";
      DATA_DIR = "${config.services.open-webui.stateDir}/data";
      HF_HOME = "${config.services.open-webui.stateDir}/hf_home";
      SENTENCE_TRANSFORMERS_HOME = "${config.services.open-webui.stateDir}/transformers_home";
      CHAT_STREAM_RESPONSE_CHUNK_MAX_BUFFER_SIZE = "20971520";

      OLLAMA_API_BASE_URL = lib.mkIf config.services.ollama.enable "http://127.0.0.1:11434";
    };
    openFirewall = true;
  };

  services.ollama = {
    enable = false;
    package = pkgs.ollama-cuda;
    host = "127.0.0.1";
    port = 11434;
    models = "/mnt/btrfs_pool/ollama_models";
    environmentVariables = {
      OLLAMA_ORIGINS = "*";
    };
  };
}
