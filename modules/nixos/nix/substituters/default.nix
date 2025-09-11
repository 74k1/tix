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
        {
          substituter = "https://cache.garnix.io";
          public-key = "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=";
        }
        {
          substituter = "https://tixpkgs.cachix.org";
          public-key = "tixpkgs.cachix.org-1:Q52x6PMD7ZuTC7oRihwp5lP9YaEaYtrfxYkwzEpjSRI=";
        }
        {
          substituter = "https://rix101.cachix.org";
          public-key = "rix101.cachix.org-1:2u9ZGi93zY3hJXQyoHkNBZpJK+GiXQyYf9J5TLzCpFY=";
        }
        {
          substituter = "https://sherlock.cachix.org";
          public-key = "sherlock.cachix.org-1:w6O/gUQB2CRFXKg7NfAAR+FGtotlj0tUi3dscRUKpX0=";
        }
      ];
}
