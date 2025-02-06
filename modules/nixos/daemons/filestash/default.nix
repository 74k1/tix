{ inputs, outputs, config, lib, pkgs, ... }:
{
  # Filestash
  # see https://github.com/MatthewCroughan/filestash-nix
  # runs on port 8334
  services = {
    filestash.enable = true;
  };
}
