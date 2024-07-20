{ config, lib, pkgs, ... }:
{
  environment.
  virtualisation.arion = {
    backend = "docker";
    projects = {
      "appflowy".settings.services = {
        "appflowy-nginx".service = {
          image = "nginx";
          container_name = "affine_nginx";
          restart = "on-failure";
          ports = [
            "80:80"
            "443:443"
          ];
          volumes = [
            "./nginx/nginx.conf:/etc/nginx/nginx.conf"
            "./nginx/ssl/certificate.crt:/etc/nginx/ssl/certificate.crt"
            "./nginx/ssl/private_key.key:/etc/nginx/ssl/private_key.key"
          ];
        };
        "appflowy-minio".service = {
          image = "minio/minio";
          restart = "on-failure";
          env_file = [
            "/home/taki/appflowy_minio_secret"
          ];
          environment = {
            MINIO_BROWSER_REDIRECT_URL = "http://localhost/minio";
            MINIO_ROOT_USER = "minioadmin";
            MINIO_ROOT_PASSWORD = "minioadmin";
          };
          command = [
            "server" "/data" "--console-address" ":9001"
          ];
          volumes = [
            "minio_data:/data"
          ];
        };
        "appflowy-postgres".service = {
          restart = "on-failure";
          build = {
            context = "./postgres";
            dockerfile = "postgres.Dockerfile"
          };
          environment = {
            POSTGRES_USER = "postgres";
            POSTGRES_DB = "postgres";
            POSTGRES_PASSWORD = "password";
            POSTGRES_HOST = "posgres";
          };
          volumes = [
            "./migrations/before:/docker-entrypoint-initdb.d"
            "postgres_data:/var/lib/postgresql/data"
          ];
        };
        "appflowy-redis".service = {
          image = "redis";
          restart = "on-failure";
        };
        "appflowy-gotrue".service = {
          image = "appflowyinc/gotrue:latest";
          restart = "on-failure";
          build = {
            context = ".";
            dockerfile = "docker/gotrue.Dockerfile";
          };
          environment = {
            # There are a lot of options to configure GoTrue. You can reference the example config:
            # https://github.com/supabase/gotrue/blob/master/example.env
            GOTRUE_SITE_URL = "appflowy-flutter://";                           # redirected to AppFlowy application
            URI_ALLOW_LIST = "*";                                              # adjust restrict if necessary
            #GOTRUE_JWT_SECRET = "${GOTRUE_JWT_SECRET}";                        # authentication secret
            #GOTRUE_JWT_EXP = "${GOTRUE_JWT_EXP}";
            GOTRUE_DB_DRIVER = "postgres";
            #API_EXTERNAL_URL = "${API_EXTERNAL_URL}";
            #DATABASE_URL = "${GOTRUE_DATABASE_URL}";
            PORT = "9999"
            #GOTRUE_SMTP_HOST = "${GOTRUE_SMTP_HOST}";                          # e.g. smtp.gmail.com
            #GOTRUE_SMTP_PORT = "${GOTRUE_SMTP_PORT}";                          # e.g. 465
            #GOTRUE_SMTP_USER = "${GOTRUE_SMTP_USER}";                          # email sender, e.g. noreply@appflowy.io
            #GOTRUE_SMTP_PASS = "${GOTRUE_SMTP_PASS}";                          # email password
            GOTRUE_MAILER_URLPATHS_CONFIRMATION = "/gotrue/verify";
            GOTRUE_MAILER_URLPATHS_INVITE = "/gotrue/verify";
            GOTRUE_MAILER_URLPATHS_RECOVERY = "/gotrue/verify";
            GOTRUE_MAILER_URLPATHS_EMAIL_CHANGE = "/gotrue/verify";
            #GOTRUE_SMTP_ADMIN_EMAIL = "${GOTRUE_SMTP_ADMIN_EMAIL}";                # email with admin privileges e.g. internal@appflowy.io
            GOTRUE_SMTP_MAX_FREQUENCY = "${GOTRUE_SMTP_MAX_FREQUENCY:-1ns}";       # set to 1ns for running tests
            GOTRUE_RATE_LIMIT_EMAIL_SENT = "${GOTRUE_RATE_LIMIT_EMAIL_SENT:-100}"; # number of email sendable per minute
            GOTRUE_MAILER_AUTOCONFIRM = "${GOTRUE_MAILER_AUTOCONFIRM:-false}";     # change this to true to skip email confirmation
            # Google OAuth config
            #GOTRUE_EXTERNAL_GOOGLE_ENABLED = "${GOTRUE_EXTERNAL_GOOGLE_ENABLED}";
            #GOTRUE_EXTERNAL_GOOGLE_CLIENT_ID = "${GOTRUE_EXTERNAL_GOOGLE_CLIENT_ID}";
            #GOTRUE_EXTERNAL_GOOGLE_SECRET = "${GOTRUE_EXTERNAL_GOOGLE_SECRET}";
            #GOTRUE_EXTERNAL_GOOGLE_REDIRECT_URI = "${GOTRUE_EXTERNAL_GOOGLE_REDIRECT_URI}";
            # GITHUB OAuth config
            #GOTRUE_EXTERNAL_GITHUB_ENABLED = "${GOTRUE_EXTERNAL_GITHUB_ENABLED}";
            #GOTRUE_EXTERNAL_GITHUB_CLIENT_ID = "${GOTRUE_EXTERNAL_GITHUB_CLIENT_ID}";
            #GOTRUE_EXTERNAL_GITHUB_SECRET = "${GOTRUE_EXTERNAL_GITHUB_SECRET}";
            #GOTRUE_EXTERNAL_GITHUB_REDIRECT_URI = "${GOTRUE_EXTERNAL_GITHUB_REDIRECT_URI}";
            # Discord OAuth config
            #GOTRUE_EXTERNAL_DISCORD_ENABLED = "${GOTRUE_EXTERNAL_DISCORD_ENABLED}";
            #GOTRUE_EXTERNAL_DISCORD_CLIENT_ID = "${GOTRUE_EXTERNAL_DISCORD_CLIENT_ID}";
            #GOTRUE_EXTERNAL_DISCORD_SECRET = "${GOTRUE_EXTERNAL_DISCORD_SECRET}";
            #GOTRUE_EXTERNAL_DISCORD_REDIRECT_URI = "${GOTRUE_EXTERNAL_DISCORD_REDIRECT_URI}";
          };
        };
        "appflowy-cloud".service = {
          image = "appflowyinc/appflowy_cloud:latest";
          build = {
            context = ".";
            dockerfile = "Dockerfile";
            args.FEATURES = "";
          };
          restart = "on-failure";
          environment = {
            RUST_LOG = "info";
            APPFLOWY_ENVIRONMENT = "production";
            # APPFLOWY_DATABASE_URL = "${APPFLOWY_DATABASE_URL}";
            APPFLOWY_REDIS_URI = "redis://redis:6379";
            APPFLOWY_GOTRUE_JWT_SECRET = ;
            APPFLOWY_GOTRUE_JWT_EXP = ;
            APPFLOWY_GOTRUE_BASE_URL = ;
            APPFLOWY_GOTRUE_EXT_URL = ;
            APPFLOWY_GOTRUE_ADMIN_EMAIL = ;
            APPFLOWY_GOTRUE_ADMIN_PASSWORD = ;
            APPFLOWY_S3_USE_MINIO = ;
            APPFLOWY_S3_ACCESS_KEY = ;
            APPFLOWY_S3_SECRET_KEY = ;
            APPFLOWY_S3_BUCKET = ;
            APPFLOWY_S3_REGION = ;
            APPFLOWY_MAILER_SMTP_HOST = ;
            APPFLOWY_MAILER_SMTP_PORT = ;
            APPFLOWY_MAILER_SMTP_USERNAME = ;
            APPFLOWY_MAILER_SMTP_PASSWORD = ;
            APPFLOWY_ACCESS_CONTROL = ;
            APPFLOWY_DATABASE_MAX_CONNECTIONS = ;
            APPFLOWY_AI_SERVER_HOST = ;
            APPFLOWY_AI_SERVER_PORT = ;
            APPFLOWY_OPENAI_API_KEY = ;
          };
        };
        "appflowy-ai".service = {
          image = "appflowyinc/appflowy_ai:latest";
          restart = "on-failure";
          environment = {
            OPENAI_API_KEY = ;
            APPFLOWY_AI_SERVER_PORT = ;
            APPFLOWY_AI_DATABASE_URL = ;
          };
        };
        "appflowy-history".service = {
          image = "appflowyinc/appflowy_history:latest";
          build = {
            context = ".";
            dockerfile = "./services/appflowy-history/Dockerfile";
          };
          environment = {
            RUST_LOG = "info";
            APPFLOWY_HISTORY_REDIS_URL = "redis://redis:6379";
            APPFLOWY_HISTORY_ENVIRONMENT = "production";
            APPFLOWY_HISTORY_DATABASE_URL = ;
        };
      };
    };
  };
}
