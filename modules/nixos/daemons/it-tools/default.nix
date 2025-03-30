{
inputs
, outputs
, config
, lib
, pkgs
, allSecrets
, ... }:
{
  imports = [
    "${inputs.nixpkgs-akotro-it-tools}/nixos/modules/services/web-apps/it-tools.nix"
  ];

  services.it-tools = {
    enable = true;
    nginx = {
      enable = true;
      domain = "it.${allSecrets.global.domain1}";
      # forceSSL = false;
      # enableACME = false;
    };
  };
}
