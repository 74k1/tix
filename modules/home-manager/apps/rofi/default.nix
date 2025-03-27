{ config, inputs, pkgs, self, ... }:
{
  programs.rofi = {
    enable = true;
    #theme = "ukiyo";
    # TODO
    font="FiraCode Nerd Font 14";
    #font = "FantasqueSansMono Nerd Font 14";
    plugins = [
      pkgs.rofi-emoji
    ];
  };
}
