{ config, lib, pkgs, ... }:
{
  services.n8n = {
    enable = true;
    settings = {
      listen_address = "0.0.0.0";
      port = 5678;
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
