{ config, inputs, pkgs, self, ... }:
{
  home.file.".xinitrc".source = ./xinitrc;
}
