{ config, lib, pkgs, inputs, outputs, ... }:
{
  services.cliphist = {
    enable = true;
    package = pkgs.cliphist;
    allowImages = true;
    # extraOptions = [
    #
    # ];
  };
}
