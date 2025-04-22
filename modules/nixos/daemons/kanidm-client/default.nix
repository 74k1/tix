{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  allSecrets,
  ...
}: {
  # kanidm
  services.kanidm = {
    enableClient = true;
    clientSettings = {
      uri = "https://auth.${allSecrets.global.domain00}";
    };
  };
}
