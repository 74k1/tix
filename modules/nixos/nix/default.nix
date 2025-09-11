{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  nix = {
    # package = pkgs.nixVersions.stable;
    package = pkgs.lixPackageSets.stable.lix;

    # Enable flakes, the new `nix` commands and better support for flakes in it
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      trusted-users = [
        "root"
        "taki"
      ];
    };
  };
}
