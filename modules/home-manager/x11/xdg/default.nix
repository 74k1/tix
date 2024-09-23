{ lib, pkgs, config, ... }:
{
  xdg.userDirs = {
    enable = true;
    desktop = "${config.home.homeDirectory}/";
    documents = "${config.home.homeDirectory}/docs";
    download = "${config.home.homeDirectory}/dl";
    music = "${config.home.homeDirectory}/";
    pictures = "${config.home.homeDirectory}/";
    publicShare = "${config.home.homeDirectory}/";
    templates = "${config.home.homeDirectory}/";
    videos = "${config.home.homeDirectory}/";
  };
}
