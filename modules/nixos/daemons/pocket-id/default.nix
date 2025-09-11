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
  age.secrets."pocketid_env" = {
    rekeyFile = "${inputs.self}/secrets/pocketid_env.age";
  };

  services.pocket-id = {
    enable = true;
    package = pkgs.pocket-id;
    settings = {
      APP_URL = "https://auth.${allSecrets.global.domain00}";
      TRUST_PROXY = true;
      ANALYTICS_DISABLED = true;

      UI_CONFIG_DISABLED = true; # config everything through nix.
      APP_NAME = lib.strings.removeSuffix ".com" allSecrets.global.domain00;
      SESSION_DURATION = 60;
      EMAILS_VERIFIED = true;
      ALLOW_OWN_ACCOUNT_EDIT = true;
      ALLOW_USER_SIGNUPS = false;
      DISABLE_ANIMATIONS = false;
      ACCENT_COLOR = "#816BFF";
      EMAIL_LOGIN_NOTIFICATION_ENABLED = true;

      SMTP_HOST = allSecrets.global.mail.sender.host;
      SMTP_PORT = allSecrets.global.mail.sender.port;
      SMTP_FROM = allSecrets.global.mail.sender.username;
      SMTP_USER = allSecrets.global.mail.sender.username;
      SMTP_PASSWORD = allSecrets.global.mail.sender.password;
      SMTP_TLS = "starttls";
      # SMTP_SKIP_CERT_VERIFY = "";

      EMAIL_API_KEY_EXPIRATION_ENABLED = true;
      EMAIL_ONE_TIME_ACCESS_AS_UNAUTHENTICATED_ENABLED = false;
      LDAP_ENABLED = false;

      # TRACING_ENABLED = true;
      # METRICS_ENABLED = true;
      # OTEL_METRICS_EXPORTER=prometheus
      # OTEL_EXPORTER_PROMETHEUS_HOST=localhost
      # OTEL_EXPORTER_PROMETHEUS_PORT=9464
    };
    environmentFile = config.age.secrets."pocketid_env".path;
  };
}
