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
    inputs.tixpkgs.nixosModules'.services.rybbit
  ];

  age.secrets."rybbit_env" = {
    rekeyFile = "${inputs.self}/secrets/rybbit_env.age";
    mode = "770";
    owner = "rybbit";
    group = "rybbit";
  };

  services.rybbit = {
    enable = true;
    host = "0.0.0.0";
    backendPort = 3035;
    environmentFile = config.age.secrets."rybbit_env".path;
    environment = {
      BASE_URL = "https://rybbit.${allSecrets.global.domain01}";
      DISABLE_TELEMETRY = true;
      DISABLE_SIGNUP = true;
    };
  };
}
