{
inputs
, outputs
, config
, lib
, pkgs
, ... }:
{
  imports = [
    "${inputs.nixpkgs-akotro-it-tools}/nixos/modules/services/web-apps/it-tools.nix"
  ];

  services.it-tools = {
    enable = true;
    nginx = {
      enable = true;
      domain = "it.74k1.sh";
      # forceSSL = false;
      # enableACME = false;
    };
  };
}
