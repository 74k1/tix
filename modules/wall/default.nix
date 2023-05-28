{ config, lib, pkgs, ... }:
with lib;
{
  options.setWall = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''enable Wall or not'';
    };
    src = mkOption {
      type = types.str;
      default = "./files/active/*";
      description = ''file or to fetch Wall from'';
    };
    random = mkOption {
      type = types.str;
      default = "--randomize ";
      description = ''randomize, if src is set to dir/* <-, otherwise set to ""'';
    };
  };
  config = {
    services.xserver.displayManager.sessionCommands = mkIf config.setWall.enable ''
      ${pkgs.feh}/bin/feh ${config.setWall.random}--bg-scale ${config.setWall.src}
    '';
  };
}
