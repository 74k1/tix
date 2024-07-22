{ config, lib, pkgs, ...}:
{
  services.outline = {
    enable = true;
    port = 3030;
    publicUrl = "https://wiki.example.com";
    storage = {
      storageType = "local";
      localRootDir = "/var/lib/outline/data";
    };
    oidcAuthentication = {
      clientId = "354e1b80-d919-4596-ac13-0f42aa8a93a6";
      clientSecretFile = "/var/lib/outline/forgejo";
      displayName = "Forgejo";
      authUrl = "https://git.example.com/login/oauth/authorize";
      tokenUrl = "https://git.example.com/login/oauth/access_token";
      userinfoUrl = "https://git.example.com/login/oauth/userinfo";
      # scopes = [ "openid" "profile" "email" ];
    };
  };
}
