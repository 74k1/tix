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
  services.n8n = {
    enable = true;
    environment = {
      GENERIC_TIMEZONE = "Europe/Zurich";
      N8N_EDITOR_BASE_URL = "https://n8n.eiri.${allSecrets.global.domain01}/";
      N8N_HOST = "n8n.eiri.${allSecrets.global.domain01}";
      N8N_LISTEN_ADDRESS = "0.0.0.0";
      N8N_PORT = 5678;
      N8N_PROTOCOL = "https";
      N8N_RESTRICT_FILE_ACCESS_TO = "/var/lib/n8n";
      TZ = "Europe/Zurich";
      WEBHOOK_URL = "https://n8n.eiri.${allSecrets.global.domain01}/";
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
