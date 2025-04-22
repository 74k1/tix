{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  allSecrets,
  ...
}: {
  age.secrets."paperless_pass" = {
    rekeyFile = "${inputs.self}/secrets/paperless_pass.age";
    # mode = "770";
    # owner = "nextcloud";
    # group = "nextcloud";
  };
  services.paperless = {
    enable = true;
    address = "${allSecrets.per_host.eiri.int_ip}";
    passwordFile = config.age.secrets."paperless_pass".path;
    consumptionDirIsPublic = true;
    consumptionDir = "/mnt/btrfs_pool/paperless/consumption";
    mediaDir = "/mnt/btrfs_pool/paperless/media";
    settings = {
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_STORE/*"
        "desktop.ini"
      ];
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
    };
  };
}
