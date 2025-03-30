{ config, lib, pkgs, allSecrets, ...}:
{
  services.outline = let
    inherit (allSecrets.global) domain0;
  in {
    enable = false;
    port = 3030;
    publicUrl = "https://wiki.${domain0}";
    storage = {
      storageType = "local";
      localRootDir = "/var/lib/outline/data";
    };
    oidcAuthentication = {
      clientId = "354e1b80-d919-4596-ac13-0f42aa8a93a6";
      clientSecretFile = "/var/lib/outline/forgejo"; # TODO
      displayName = "Forgejo";
      authUrl = "https://git.${domain0}/login/oauth/authorize";
      tokenUrl = "https://git.${domain0}/login/oauth/access_token";
      userinfoUrl = "https://git.${domain0}/login/oauth/userinfo";
      # scopes = [ "openid" "profile" "email" ];
    };
  };
}
