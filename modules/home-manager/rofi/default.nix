{ config, inputs, pkgs, self, ... }:
{
  programs.rofi = {
    enable = true;
#    theme = "ukiyo";
    font="FiraCode Nerd Font 14";
    #font = "FantasqueSansMono Nerd Font 14";
    plugins = [
      pkgs.rofi-emoji
    ];
  };
}
