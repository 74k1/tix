{
  lib,
  pkgs,
  config,
  ...
}:
{
  nix.settings =
    lib.foldl'
      (
        acc:
        { substituter, public-key }:
        {
          substituters = acc.substituters ++ [ substituter ];
          trusted-public-keys = acc.trusted-public-keys ++ [ public-key ];
        }
      )
      {
        substituters = [ ];
        trusted-public-keys = [ ];
      }
      [
        {
          substituter = "http://nix-community.cachix.org";
          public-key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
        }
      ];
}
