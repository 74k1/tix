{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  wallpaper_image = pkgs.fetchurl {
    url = "https://upload.wikimedia.org/wikipedia/commons/0/07/Johan_Christian_Dahl_-_View_of_Dresden_by_Moonlight_-_Google_Art_Project.jpg";
    name = "wallpaper.jpg";
    hash = "sha256-MjBzldNqNQa1aPoxUPyimovl+YSA4m74Dx7MIsswxtU=";
  };
in {

}
