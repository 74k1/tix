{ inputs
, outputs
, config
, lib
, pkgs
, ... }:
{
  age.secrets."docmost_env_secret" = {
    rekeyFile = "${inputs.self}/secrets/docmost_env_secret.age";
    mode = "770";
    # owner = "";
    # group = "";
  };
  # environment.systemPackages = with pkgs; [
  #   nodejs_22
  # ];
  virtualisation.arion = {
    backend = "docker";
    projects = {
      "docmost".settings.services = {
        "docmost".service = {
          image = "docmost/docmost:latest";
          container_name = "docmost_selfhosted";
          restart = "unless-stopped";
          ports = [
            "3033:3000"
          ];
          depends_on = {
            "docmost-db".condition = "service_healthy";
            "docmost-redis".condition = "service_healthy";
          };
          volumes = [
            "/mnt/btrfs_pool/docmost_storage:/app/data/storage"
          ];
          env_file = [
            # "/home/taki/affine_secret"
            config.age.secrets."docmost_env_secret".path
          ];
          environment = {
            APP_URL = "https://forever.example.com"; # TODO
            JWT_TOKEN_EXPIRES_IN = "30d";
            MAIL_DRIVER = "smtp";
            DATABASE_URL = "postgresql://docmost:docmost@docmost-db:5432/docmost?schema=public";
            REDIS_URL = "redis://docmost-redis:6379";
          };
        };
        "docmost-db".service = {
          image = "postgres:16-alpine";
          container_name = "docmost_db";
          restart = "unless-stopped";
          environment = {
            POSTGRES_DB = "docmost";
            POSTGRES_USER = "docmost";
            POSTGRES_PASSWORD = "docmost";
          };
          volumes = [
            "/var/lib/docmost/db:/var/lib/postgresql/data"
          ];
          healthcheck = {
            test = [ "CMD-SHELL" "pg_isready -U docmost" ];
            interval = "10s";
            timeout = "5s";
            retries = 5;
          };
        };
        "docmost-redis".service = {
          image = "redis:7.2-alpine";
          container_name = "docmost_redis"; 
          restart = "unless-stopped";
          volumes = [
            "/var/lib/docmost/redis:/data"
          ];
          healthcheck = {
            test = [ "CMD" "redis-cli" "--raw" "incr" "ping" ];
            interval = "10s";
            timeout = "5s";
            retries = 5;
          };
        };
      };
    };
  };
}
