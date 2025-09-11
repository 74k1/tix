{
  config,
  pkgs,
  inputs,
  outputs,
  allSecrets,
  ...
}:
{
  imports = [
    inputs.tixpkgs.nixosModules'.services.rsshub
  ];

  age.secrets."rsshub_env" = {
    rekeyFile = "${inputs.self}/secrets/rsshub_env.age";
  };

  services.rsshub = {
    enable = true;
    settings = {
       caching.enable = true;
    };
    environment = {
      PORT = 1200;
    };
    environmentFile = config.age.secrets."rsshub_env".path;
  };
}
