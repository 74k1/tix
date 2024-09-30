{ inputs, outputs, config, lib, pkgs, ... }:
{
  age.secrets."affine_secret" = {
    rekeyFile = "${inputs.self}/secrets/affine_secret.age";
    mode = "770";
    # owner = "";
    # group = "";
  };
  environment.systemPackages = with pkgs; [
    nodejs_22
  ];
  virtualisation.arion = {
    backend = "docker";
    projects = {
      "affine".settings.services = {
        "affine".service = {
          image = "ghcr.io/toeverything/affine-graphql:stable";
          container_name = "affine_selfhosted";
          restart = "unless-stopped";
          command = [
            "sh"
            "-c"
            "node ./scripts/self-host-predeploy && node ./dist/index.js"
          ];
          ports = [
            "3010:3010"
            "5555:5555"
          ];
          depends_on = {
            "affine-redis".condition = "service_healthy";
            "affine-postgres".condition = "service_healthy";
          };
          volumes = [
            "/var/lib/affine/self-host/config:/root/.affine/config"
            "/mnt/btrfs_pool/affine_storage:/root/.affine/storage"
          ];
          env_file = [
            # "/home/taki/affine_secret"
            config.age.secrets."affine_secret".path
          ];
          environment = {
            NODE_OPTIONS = "--import=./scripts/register.js";
            AFFINE_CONFIG_PATH="/root/.affine/config";
            REDIS_SERVER_HOST="redis";
            DATABASE_URL="postgres://affine:affine@affine-postgres:5432/affine";
            NODE_ENV="production";
            MAILER_SENDER="mail@example.com";
            AFFINE_SERVER_HOST="forever.example.com";
            AFFINE_SERVER_PORT="";
            AFFINE_SERVER_HTTPS="true";
            # AFFINE_ADMIN_EMAIL=${AFFINE_ADMIN_EMAIL};
            # AFFINE_ADMIN_PASSWORD=${AFFINE_ADMIN_PASSWORD};
            # Telemetry allows us to collect data on how you use the affine. This data will helps us improve the app and provide better features.
            # Uncomment next line if you wish to quit telemetry.
            TELEMETRY_ENABLE = "false";
          };
        };

        "affine-redis".service = {
          image = "redis";
          container_name = "affine_redis";
          restart = "unless-stopped";
          volumes = [
            "/var/lib/affine/self-host/redis:/data"
          ];
          healthcheck = {
            test = [ "CMD" "redis-cli" "--raw" "incr" "ping" ];
            interval = "10s";
            timeout = "5s";
            retries = 5;
          };
        };

        "affine-postgres".service = {
          image = "postgres";
          container_name = "affine_postgres";
          restart = "unless-stopped";
          volumes = [
            "/var/lib/affine/self-host/postgres:/var/lib/postgresql/data"
          ];
          environment = {
            POSTGRES_USER = "affine";
            POSTGRES_PASSWORD = "affine";
            POSTGRES_DB = "affine";
            PGDATA = "/var/lib/postgresql/data/pgdata";
          };
          healthcheck = {
            test = [ "CMD-SHELL" "pg_isready -U affine" ];
            interval = "10s";
            timeout = "5s";
            retries = 5;
          };
        };
      };
    };
  };
}
