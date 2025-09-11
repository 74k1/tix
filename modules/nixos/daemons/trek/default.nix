{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  # self,
  allSecrets,
  ...
}:
{
  imports = [
    inputs.tixpkgs.nixosModules'.services.trek
  ];

  age.secrets = {
    "trek_encryption_key" = {
      rekeyFile = "${inputs.self}/secrets/trek_encryption_key.age";
      # mode = "770";
      owner = "trek";
      group = "trek";
    };
    "trek_env" = {
      rekeyFile = "${inputs.self}/secrets/trek_env.age";
      # mode = "770";
      owner = "trek";
      group = "trek";
    };
  };

  services.trek = {
    enable = true;
    host = "0.0.0.0";
    port = 3320;
    domain = "trek.i.${allSecrets.global.domain03}";
    # vhost is hand-written in configuration.nix, so the module can't infer TLS
    appUrl = "https://trek.i.${allSecrets.global.domain03}";
    encryptionKeyFile = config.age.secrets."trek_encryption_key".path;
    environmentFile = config.age.secrets."trek_env".path;
  };
}
