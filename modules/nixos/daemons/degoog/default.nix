{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  allSecrets,
  ...
}:
{
  imports = [
    inputs.tixpkgs.nixosModules'.services.degoog
  ];

  age.secrets."degoog_env" = {
    rekeyFile = "${inputs.self}/secrets/degoog_env.age";
    # mode = "770";
    # owner = "forgejo";
    # group = "forgejo";
  };

  services.degoog = {
    enable = true;
    hostname = "search.i.${allSecrets.global.domain03}";

    nginx = {
      serverName = "search.i.${allSecrets.global.domain03}";
      useACMEHost = "i.${allSecrets.global.domain03}";
      forceSSL = true;
      # openFirewall = true;
    };

    environment = {
      DEGOOG_WIZARD = "true";
      DEGOOG_DEFAULT_SEARCH_LANGUAGE = "en-US";
      DEGOOG_PUBLIC_INSTANCE = "true";
      DEGOOG_DISTRUST_PROXY = "0";
    };

    # DEGOOG_SETTINGS_PASSWORDS
    # DEGOOG_SETTINGS_PATH
    environmentFile = config.age.secrets."degoog_env".path;
  };
}
