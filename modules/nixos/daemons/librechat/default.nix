{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.librechat-docker;
in {
  options.services.librechat-docker = {
    enable = lib.mkEnableOption "LibreChat Docker Service";
    
    port = lib.mkOption {
      type = lib.types.port;
      default = 3080;
      description = "Port to expose LibreChat";
    };

    mongoUsername = lib.mkOption {
      type = lib.types.str;
      default = "admin";
      description = "MongoDB username";
    };

    mongoPassword = lib.mkOption {
      type = lib.types.str;
      default = "password";
      description = "MongoDB password";
    };

    jwtSecret = lib.mkOption {
      type = lib.types.str;
      description = "JWT secret for authentication";
    };

    allowRegistration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to allow user registration";
    };

    openaiApiKey = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "OpenAI API key";
    };

    anthropicApiKey = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Anthropic API key";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.arion = {
      backend = "docker";
      projects.librechat = {
        settings = {
          project.name = "librechat";
          docker-compose = {
            volumes = {
              mongodb_data = {};
            };
          };
          services = {
            librechat = {
              service = {
                image = "ghcr.io/danny-avila/librechat:latest";
                ports = ["${toString cfg.port}:3080"];
                environment = {
                  PORT = "3080";
                  MONGO_URI = "mongodb://${cfg.mongoUsername}:${cfg.mongoPassword}@mongodb:27017/";
                  ALLOW_REGISTRATION = toString cfg.allowRegistration;
                  JWT_SECRET = cfg.jwtSecret;
                  OPENAI_API_KEY = cfg.openaiApiKey;
                  ANTHROPIC_API_KEY = cfg.anthropicApiKey;
                };
                depends_on = ["mongodb"];
                restart = "unless-stopped";
              };
            };

            mongodb = {
              service = {
                image = "mongo";
                environment = {
                  MONGO_INITDB_ROOT_USERNAME = cfg.mongoUsername;
                  MONGO_INITDB_ROOT_PASSWORD = cfg.mongoPassword;
                };
                volumes = [
                  "mongodb_data:/data/db"
                ];
                restart = "unless-stopped";
              };
            };
          };
        };
      };
    };

    # Enable required services
    # virtualisation.docker.enable = true;
  };
}
