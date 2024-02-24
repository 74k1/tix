{ config, lib, pkgs, ... }:
{
  # GITEA
  services.forgejo = {
    enable = true;
    settings = {
      service.DISABLE_REGISTRATION = true;
    #  server.DOMAIN = "git.74k1.sh";
    };
  };
}
