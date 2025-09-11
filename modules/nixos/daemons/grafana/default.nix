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
  # age.secrets."karakeep_secret" = {
  #   rekeyFile = "${inputs.self}/secrets/karakeep_secret.age";
  #   # mode = "770";
  #   # owner = "";
  #   # group = "";
  # };

  services = {
    grafana = {
      # Dashboard
      enable = true;
      declarativePlugins = with pkgs.grafanaPlugins; [
        # grafana-piechart-panel
        grafana-metricsdrilldown-app
        grafana-lokiexplore-app
      ];
      settings = {
        analytics.reporting_enabled = false;
        users.allow_sign_up = false;

        server = {
          domain = "grafana.i.${allSecrets.global.domain03}";
          root_url = "https://grafana.i.${allSecrets.global.domain03}";
          enforce_domain = true;
          enable_gzip = true;
          http_addr = "0.0.0.0";
          http_port = 3100;
        };

        auth.disable_login_form = true;
        "auth.generic_oauth" = {
          enabled = true;
          name = "Auth";
          icon = "signin";
          allow_sign_up = true;
          client_id = "grafana";
          client_secret = allSecrets.per_service.pocket-id.clients.grafana.secret;
          scopes = "openid email profile grafana_role";
          inherit (allSecrets.per_service.pocket-id) auth_url token_url;
          api_url = allSecrets.per_service.pocket-id.userinfo_url;
          use_pkce = true;
          allow_assign_grafana_admin = true;
          role_attribute_path = "grafana_role";
          # role_attribute_path = "contains(groups[*], 'server_admin') && 'GrafanaAdmin' || contains(groups[*], 'admin') && 'Admin' || contains(groups[*], 'editor') && 'Editor' || 'Viewer'";
        };

        security.secret_key = allSecrets.per_service.grafana.secret_key;
      };

      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Loki";
            type = "loki";
            access = "proxy";
            url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
            orgId = 1;
            editable = true;
            # basicAuth = true;
            # basicAuthUser = "${config.node.name}+grafana-loki-basic-auth-password";
            # secureJsonData.basicAuthPassword = "$__file{${config.age.secrets.grafana-loki-basic-auth-password.path}}";
          }

          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://127.0.0.1:${toString config.services.prometheus.port}";
            orgId = 1;
            editable = true;
            # basicAuth = true;
            # basicAuthUser = "${config.node.name}+grafana-loki-basic-auth-password";
            # secureJsonData.basicAuthPassword = "$__file{${config.age.secrets.grafana-loki-basic-auth-password.path}}";
          }
        ];
        # dashboards.settings.providers = [
        #   {
        #     name = "default";
        #     options.path = pkgs.stdenv.mkDerivation {
        #       name = "grafana-dashboards";
        #       src = ./grafana-dashboards;
        #       installPhase = ''
        #         mkdir -p $out/
        #         install -D -m755 $src/*.json $out/
        #       '';
        #     };
        #   }
        # ];
      };
    };
  };
}
