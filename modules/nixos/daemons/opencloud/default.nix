{
  config,
  pkgs,
  inputs,
  outputs,
  allSecrets,
  lib,
  ...
}:
{
  # age.secrets."opencloud_env" = {
  #   rekeyFile = "${inputs.self}/secrets/opencloud_env.age";
  #   # mode = "770";
  #   owner = "opencloud";
  #   group = "opencloud";
  # };

  services.opencloud = {
    enable = true;
    package = pkgs.opencloud;
    # webPackage = pkgs.opencloud.web;

    url = "https://files.${allSecrets.global.domain00}";

    stateDir = "/mnt/btrfs_pool/opencloud_data";
    address = "0.0.0.0";
    port = 9200;

    settings = {
      proxy = {
        http.addr = "0.0.0.0:${builtins.toString config.services.opencloud.port}";
        tls = false;
        auto_provision_accounts = true;
        oidc = {
          issuer = allSecrets.global.oidc.issuerUrl;
          rewrite_well_known = true;
        };
        role_assignment = {
          driver = "oidc";
          oidc_role_mapper.role_claim = "opencloud_roles";
        };
        csp_config_file_location = "/etc/opencloud/csp.yaml";
      };
      csp.directives = {
        child-src = [ "'self'" ];
        connect-src = [
          "'self'"
          "blob:"
          "https://files.${allSecrets.global.domain00}/"
          allSecrets.global.oidc.issuerUrl
          allSecrets.global.oidc.discoveryUrl
          "https://raw.githubusercontent.com/opencloud-eu/awesome-apps/"
          "https://update.opencloud.eu/"
        ];
        default-src = [ "'none'" ];
        font-src = [ "'self'" ];
        frame-ancestors = [ "'self'" ];
        frame-src = [
          "'self'"
          "blob:"
          allSecrets.global.oidc.issuerUrl
          allSecrets.global.oidc.discoveryUrl
          "https://embed.diagrams.net/"
        ];
        img-src = [
          "'self'"
          "data:"
          "blob:"
          "https://raw.githubusercontent.com/opencloud-eu/awesome-apps/"
        ];
        manifest-src = [ "'self'" ];
        media-src = [ "'self'" ];
        object-src = [
          "'self'"
          "blob:"
        ];
        script-src = [
          "'self'"
          "'unsafe-inline'"
          "'unsafe-eval'"
          "https://files.${allSecrets.global.domain00}/"
          allSecrets.global.oidc.issuerUrl
        ];
        style-src = [
          "'self'"
          "'unsafe-inline'"
        ];
      };
      web.web.config.oidc.scope = "openid profile email opencloud_roles";
    };

    environment = {
      FRONTEND_CHECK_FOR_UPDATES = "false";
      START_ADDITIONAL_SERVICES = "notifications auth-app";

      # = LOG =
      OC_LOG_LEVEL = "info";
      OC_LOG_COLOR = "true";
      # OC_LOG_PRETTY = "true";

      # = TLS & Proxy =
      # INSECURE = "false";
      # OC_INSECURE = "true";
      PROXY_TLS = "false";
      PROXY_TRUSTED_PROXIES = "10.100.0.2";
      # PROXY_INSECURE_BACKENDS = "true";
      PROXY_OIDC_REWRITE_WELLKNOWN = "true";
      PROXY_USER_OIDC_CLAIM = "preferred_username";
      PROXY_USER_CS3_CLAIM = "username";
      PROXY_ROLE_ASSIGNMENT_DRIVER = "oidc";
      WEB_OPTION_ACCOUNT_EDIT_LINK_HREF = "https://auth.${allSecrets.global.domain00}";

      # = URL Configuration =
      OC_URL = "https://files.${allSecrets.global.domain00}";
      OC_DOMAIN = "files.${allSecrets.global.domain00}";

      # = OIDC =
      OC_OIDC_ISSUER = "https://auth.${allSecrets.global.domain00}";
      OC_EXCLUDE_RUN_SERVICES = "idp";
      OC_ADMIN_USER_ID = "";
      SETTINGS_SETUP_DEFAULT_ASSIGNMENTS = "false";
      GRAPH_ASSIGN_DEFAULT_USER_ROLE = "false";
      GRAPH_USERNAME_MATCH = "none";

      # = SMTP =
      SMTP_HOST = allSecrets.global.mail.sender.host;
      SMTP_PORT = allSecrets.global.mail.sender.port;
      SMTP_SENDER = allSecrets.global.mail.sender.username;
      SMTP_USERNAME = allSecrets.global.mail.sender.username;
      SMTP_PASSWORD = allSecrets.global.mail.sender.password;
      SMTP_TRANSPORT_ENCRYPTION = "none";
      SMTP_INSECURE = "true";
      SMTP_AUTHENTICATION = "auto";

      # = AUTH APP =
      PROXY_ENABLE_APP_AUTH = "true";
    };
  };

  environment.systemPackages = [ pkgs.opencloud ];

  # btrfs compression fix
  systemd.services.opencloud = lib.mkIf config.services.opencloud.enable {
    preStart = ''
      natsDir="${config.services.opencloud.stateDir}/nats"
      mkdir -p "$natsDir"
      # Only set NOCOW on empty dirs (chattr +C only works before data exists)
      if [ -z "$(ls -A "$natsDir" 2>/dev/null)" ]; then
        chattr +C "$natsDir" 2>/dev/null || true
      fi
      chown -R opencloud:opencloud "$natsDir"
    '';
  };
}
