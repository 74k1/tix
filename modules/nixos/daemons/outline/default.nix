{ inputs, outputs, config, lib, pkgs, allSecrets, ...}:
{
  age.secrets."outline_forgejo_oidc_secret" = {
    rekeyFile = "${inputs.self}/secrets/outline_forgejo_oidc_secret.age";
    # mode = "770";
    # owner = "nextcloud";
    # group = "nextcloud";
  };

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
      clientSecretFile = config.age.secrets."outline_forgejo_oidc_secret".path;
      displayName = "Forgejo";
      authUrl = "https://git.${domain0}/login/oauth/authorize";
      tokenUrl = "https://git.${domain0}/login/oauth/access_token";
      userinfoUrl = "https://git.${domain0}/login/oauth/userinfo";
      # scopes = [ "openid" "profile" "email" ];
    };
  };
}
