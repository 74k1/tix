{
  inputs,
  outputs,
  config,
  lib,
  allSecrets,
  pkgs,
  ...
}:
{
  age.secrets = {
    "sure_secret_key" = {
      rekeyFile = "${inputs.self}/secrets/sure_secret_key.age";
      # mode = "770";
      owner = "sure";
      group = "sure";
    };
    "sure_env" = {
      rekeyFile = "${inputs.self}/secrets/sure_env.age";
      # mode = "770";
      owner = "sure";
      group = "sure";
    };
  };

  imports = [
    "${inputs.pjrm-sure}/nixos/modules/services/web-apps/sure.nix"
  ];

  services.sure = {
    enable = true;
    package = inputs.pjrm-sure.legacyPackages.${pkgs.system}.sure;
    webPort = 3213;
    forceSSL = true;
    secretKeyBaseFile = config.age.secrets."sure_secret_key".path;
    localDomain = "fin.${allSecrets.global.domain00}";
    environment = {
      ONBOARDING_STATE = "closed";

      # openrouter
      # OPENAI_ACCESS_TOKEN=your-openrouter-api-key
      # OPENAI_URI_BASE=https://openrouter.ai/api/v1
      # OPENAI_MODEL=google/gemini-2.0-flash-exp
      # or ollama
      OPENAI_ACCESS_TOKEN = "ollama-local";
      OPENAI_URI_BASE = "http://192.168.1.108:11434/v1";
      OPENAI_MODEL = "qwen3.6:35b";
      # more config
      LLM_CONTEXT_WINDOW = "51200";
      LLM_MAX_RESPONSE_TOKENS = "4096";
      LLM_SYSTEM_PROMPT_RESERVE = "512";
      LLM_MAX_ITEMS_PER_CALL = "50";
      # OPENAI_SUPPORTS_PDF_PROCESSING = "false"; #if model has no vision

      # OIDC
      AUTH_PROVIDERS_SOURCE = "db";
      AUTH_LOCAL_LOGIN_ENABLED = "false";
      AUTH_LOCAL_ADMIN_OVERRIDE_ENABLED = "false";
      AUTH_JIT_MODE = "create_and_link";
    };

    # SMTP_ADDRESS
    # SMTP_PORT
    # SMTP_DOMAIN
    # SMTP_USERNAME
    # SMTP_PASSWORD
    # SMTP_AUTHENTICATION
    # SMTP_ENABLE_STARTTLS_AUTO
    environmentFiles = [
      config.age.secrets."sure_env".path
    ];
  };
}
