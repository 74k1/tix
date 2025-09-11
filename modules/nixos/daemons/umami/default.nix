{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  # imports = [
  #   "${inputs.nixpkgs-master}/nixos/modules/services/web-apps/umami.nix"
  #   # "${inputs.diogotcorreira-umami}/pkgs/by-name/um/umami/package.nix"
  # ];

  age.secrets."umami_secret" = {
    rekeyFile = "${inputs.self}/secrets/umami_secret.age";
    mode = "770";
    generator.script = "alnum";
    # owner = "";
    # group = "";
  };

  services.umami = {
    enable = true;
    package = pkgs.master.umami;
    settings = {
      APP_SECRET_FILE = config.age.secrets."umami_secret".path;
      TRACKER_SCRIPT_NAME = [ "umami.js" ];
      DISABLE_TELEMETRY = true;
      HOSTNAME = "0.0.0.0";
      PORT = 3034;
      CLIENT_IP_HEADER = "X-Real-IP";
    };
  };
}
