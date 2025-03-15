{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  # age.secrets."paperless_pass" = {
  #   rekeyFile = "${inputs.self}/secrets/paperless_pass.age";
  #   # mode = "770";
  #   # owner = "nextcloud";
  #   # group = "nextcloud";
  # };
  services.vector = {
    enable = true;
    # passwordFile = config.age.secrets."paperless_pass".path;
  };
}
