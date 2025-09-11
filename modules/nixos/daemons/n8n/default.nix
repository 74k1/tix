{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.n8n = {
    enable = true;
    environment = {
      N8N_LISTEN_ADDRESS = "0.0.0.0";
      N8N_PORT = 5678;
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
