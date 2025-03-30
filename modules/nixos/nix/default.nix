{ inputs, config, lib, pkgs, ... }:
{
  nix = {
    package = inputs.rix101.packages.${pkgs.hostPlatform.system}.nix-enraged;

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
