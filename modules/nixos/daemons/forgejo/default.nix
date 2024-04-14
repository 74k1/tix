{ config, lib, pkgs, ... }:
{
  # GITEA
  services.forgejo = {
    enable = true;
    settings = {
      service = {
        DISABLE_REGISTRATION = true;
        ENABLE_REVERSE_PROXY_AUTHENTICATION = true;
      };
      server = {
        DOMAIN = "git.example.com";
        ROOT_URL = "https://git.example.com/";
      };
    };
  };
}
