{
  allSecrets,
  config,
  inputs,
  lib,
  outputs,
  pkgs,
  ...
}:
{
  age.secrets."n8n_runners_auth_token" = {
    rekeyFile = "${inputs.self}/secrets/n8n_runners_auth_token.age";
    # mode = "770";
    # owner = "opencloud";
    # group = "opencloud";
  };

  services.n8n = {
    enable = true;
    environment = {
      GENERIC_TIMEZONE = "Europe/Zurich";
      N8N_EDITOR_BASE_URL = "https://n8n.i.${allSecrets.global.domain03}/";
      N8N_HOST = "n8n.eiri.${allSecrets.global.domain01}";
      N8N_LISTEN_ADDRESS = "0.0.0.0";
      N8N_PORT = 5678;
      N8N_PROTOCOL = "https";
      N8N_RESTRICT_FILE_ACCESS_TO = "/var/lib/n8n;/var/lib/private/n8n";
      # N8N_RUNNERS_ENABLED = "false";
      N8N_RUNNERS_AUTH_TOKEN_FILE = config.age.secrets."n8n_runners_auth_token".path;
      TZ = "Europe/Zurich";
      WEBHOOK_URL = "https://n8n.i.${allSecrets.global.domain03}/";
    };
    taskRunners = {
      enable = true;
    };
  };

  # environment.systemPackages = with pkgs; [ nodejs ];

  # systemd.services.n8n = {
  #   serviceConfig = {
  #     Environment = [
  #       "PATH=${lib.makeBinPath [ pkgs.nodejs pkgs.n8n ]}:\${PATH}"
  #     ];
  #   };
  # };
}
