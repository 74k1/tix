{ config, lib, pkgs, ... }:
{
  nix = {
    package = pkgs.nixVersions.stable;

    # Enable flakes, the new `nix` commands and better support for flakes in it
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      trusted-users = [ "root" "taki" ];
      # cores = 4;
      # max-jobs = 1;
    };
  };
}
