{ config, lib, pkgs, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixVersions.stable;

    # Enable flakes, the new `nix` commands and better support for flakes in it
    extraOptions = ''
      experimental-features = nix-command flakes repl-flake
    '';
  };

}
