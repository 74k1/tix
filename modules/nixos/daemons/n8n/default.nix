{ config, lib, pkgs, ... }:
{
  services.n8n.enable = true;
  environment.systemPackages = with pkgs; [ nodejs ];
  
  systemd.services.n8n = {
    serviceConfig = {
      Environment = [
        "PATH=${lib.makeBinPath [ pkgs.nodejs pkgs.n8n ]}:\${PATH}"
      ];
    };
  };
}
