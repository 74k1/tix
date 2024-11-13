{
inputs
, outputs
, config
, lib
, pkgs
, ... }:
{
  imports = [
    "${inputs.jvanbruegge-linkwarden}/nixos/modules/services/web-apps/linkwarden.nix"
    # "${inputs.jvanbruegge-linkwarden}/pkgs/by-name/pr/prisma/package.nix"
  ];

  age.secrets."linkwarden_secret" = {
    rekeyFile = "${inputs.self}/secrets/linkwarden_secret.age";
    mode = "770";
    # owner = "";
    # group = "";
  };

  services.linkwarden = {
    enable = true;
    package = inputs.jvanbruegge-linkwarden.outputs.legacyPackages.x86_64-linux.linkwarden;
    enableRegistration = false;
    # environment = {
    #   # check https://docs.linkwarden.app/self-hosting/environment-variables
    # };
    secretsFile = config.age.secrets."linkwarden_secret".path;
    host = "0.0.0.0";
    port = 3030;
  };
}
