{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  age.secrets."litellm_env" = {
    rekeyFile = "${inputs.self}/secrets/litellm_env.age";
    # mode = "770";
    # owner = "nextcloud";
    # group = "nextcloud";
  };

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

      OLLAMA_API_BASE_URL = lib.mkIf config.services.ollama.enable "http://127.0.0.1:11434";
    };
    openFirewall = true;
  };

  services.ollama = {
    enable = false;
    host = "127.0.0.1";
    port = 11434;
    acceleration = "cuda";
    models = "/mnt/btrfs_pool/ollama_models";
    environmentVariables = {
      OLLAMA_ORIGINS = "*";
    };
  };

  services.postgresql = {
    enable = true;
    ensureUsers = [
      {
        name = "litellm";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [ "litellm" ];
    authentication = ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
  };

  virtualisation.quadlet =
    let
      inherit (config.virtualisation.quadlet) networks pods;
    in
    {
      containers."litellm" =
        let
          litellm_config = {
            model_list = [
              # DEEPSEEK 🐋
              {
                model_name = "deepseek-coder";
                litellm_params = {
                  model = "deepseek/deepseek-coder";
                  api_key = "os.environ/DEEPSEEK_API_KEY";
                };
              }
              {
                model_name = "deepseek-reasoner";
                litellm_params = {
                  model = "deepseek/deepseek-reasoner";
                  api_key = "os.environ/DEEPSEEK_API_KEY";
                };
              }
              {
                model_name = "deepseek-chat";
                litellm_params = {
                  model = "deepseek/deepseek-chat";
                  api_key = "os.environ/DEEPSEEK_API_KEY";
                };
              }

              # Claude 🧠
              {
                model_name = "claude-4-sonnet-20250514";
                litellm_params = {
                  model = "anthropic/claude-4-sonnet-20250514";
                  api_key = "os.environ/ANTHROPIC_API_KEY";
                };
              }
              {
                model_name = "claude-3-7-sonnet-20250219";
                litellm_params = {
                  model = "anthropic/claude-3-7-sonnet-20250219";
                  api_key = "os.environ/ANTHROPIC_API_KEY";
                };
              }

              # OpenAI 🤖
              {
                model_name = "*";
                litellm_params = {
                  model = "openai/*"; # All OpenAI Models
                  api_key = "os.environ/OPENAI_API_KEY";
                };
              }
            ];
          };
          litellm_yaml = pkgs.writeText "config.yaml" (lib.generators.toYAML { } litellm_config);
        in
        {
          autoStart = true;
          serviceConfig = {
            RestartSec = "10";
            Restart = "always";
          };
          containerConfig = {
            image = "ghcr.io/berriai/litellm-database:main-latest";
            autoUpdate = "registry";
            publishPorts = [ "3336:4000" ];
            # userns = "keep-id";
            networks = [ "podman" ];
            # pod = pods.servarr.ref;
            environments = {
              DATABASE_URL = "postgresql://litellm@localhost/litellm?host=/var/run/postgresql&schema=litellm";
              STORE_MODEL_IN_DB = "true";
              # LITELLM_RUN_DB_MIGRATIONS = "true";
            };
            environmentFiles = [
              # required:
              # LITELLM_MASTER_KEY (rand key, starting with "sk")
              # LITELLM_SALT_KEY (rand key, starting with "sk")
              # ANTHROPIC_API_KEY
              # DEEPSEEK_API_KEY
              # OPENAI_API_KEY

              # optional:
              # OPENAI_BASE_URL
              # OPENAI_ORGANIZATION
              config.age.secrets."litellm_env".path
            ];
            # environmentHost = true;
            # podmanArgs = [ ];
            volumes = [
              "${litellm_yaml}:/app/config.yaml:ro"
              "/var/run/postgresql:/var/run/postgresql"
            ];
          };
        };
    };

  # services.litellm = {
  #   enable = true;
  #   # package = litellm-1-70-1;
  #   # package = pkgs.local.litellm;
  #   host = "0.0.0.0";
  #   port = 3336;
  #   # environment = {
  #   #   PRISMA_CACHE_DIR="/var/cache/litellm";
  #   # };
  #   environmentFile = config.age.secrets."litellm_env".path;
  #
  #   # required:
  #   # LITELLM_MASTER_KEY (rand key, starting with "sk")
  #   # LITELLM_SALT_KEY (rand key, starting with "sk")
  #   # ANTHROPIC_API_KEY
  #   # DEEPSEEK_API_KEY
  #   # OPENAI_API_KEY
  #
  #   # optional:
  #   # OPENAI_BASE_URL
  #   # OPENAI_ORGANIZATION
  #
  #   settings = {
  #     general_settings = {
  #       # database_url = "postgresql://litellm?host=/run/postgresql";
  #       database_url = "postgresql://litellm@127.0.0.1:${builtins.toString config.services.postgresql.port}/litellm";
  #     };
  #     # See https://docs.litellm.ai/docs/providers/
  #     model_list = [
  #       # DEEPSEEK 🐋
  #       {
  #         model_name = "deepseek-coder";
  #         litellm_params = {
  #           model = "deepseek/deepseek-coder";
  #           api_key = "os.environ/DEEPSEEK_API_KEY";
  #         };
  #       }
  #       {
  #         model_name = "deepseek-reasoner";
  #         litellm_params = {
  #           model = "deepseek/deepseek-reasoner";
  #           api_key = "os.environ/DEEPSEEK_API_KEY";
  #         };
  #       }
  #       {
  #         model_name = "deepseek-chat";
  #         litellm_params = {
  #           model = "deepseek/deepseek-chat";
  #           api_key = "os.environ/DEEPSEEK_API_KEY";
  #         };
  #       }
  #
  #       # Claude 🧠
  #       {
  #         model_name = "claude-4-sonnet-20250514";
  #         litellm_params = {
  #           model = "anthropic/claude-4-sonnet-20250514";
  #           api_key = "os.environ/ANTHROPIC_API_KEY";
  #         };
  #       }
  #       {
  #         model_name = "claude-3-7-sonnet-20250219";
  #         litellm_params = {
  #           model = "anthropic/claude-3-7-sonnet-20250219";
  #           api_key = "os.environ/ANTHROPIC_API_KEY";
  #         };
  #       }
  #
  #       # OpenAI 🤖
  #       {
  #         model_name = "*";
  #         litellm_params = {
  #           model = "openai/*"; # All OpenAI Models
  #           api_key = "os.environ/OPENAI_API_KEY";
  #         };
  #       }
  #     ];
  #   };
  # };
}
