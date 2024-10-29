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

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to environment file containing secrets";
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
                  MONGO_URI = "mongodb://${cfg.mongoUsername}:${cfg.mongoPassword}@mongodb:27017/LibreChat?retryWrites=true";
                  # Basic settings with secure defaults
                  ALLOW_REGISTRATION = "false";
                  ALLOW_SOCIAL_LOGIN = "false";
                  SESSION_EXPIRY = toString (1000 * 60 * 15); # 15 minutes
                  REFRESH_TOKEN_EXPIRY = toString ((1000 * 60 * 60 * 24) * 7); # 7 days
                };
                env_file = lib.mkIf (cfg.environmentFile != null) [
                  cfg.environmentFile
                ];
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
  };
}
