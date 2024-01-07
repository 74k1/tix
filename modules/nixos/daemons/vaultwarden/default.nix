{ config, lib, pkgs, ... }:
{
  # VAULTWARDEN
  services.vaultwarden = {
    enable = true;
    environmentFile = "/home/taki/vaultwarden_env_secrets";
    config = {
      DOMAIN = "https://vw.taki.moe/";
      SIGNUPS_ALLOWED = false;
    };
  };
}
