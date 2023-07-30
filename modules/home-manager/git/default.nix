{ config, inputs, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "74k1";
    userEmail = "git@temporamail.net";
    extraConfig.core.editor = "nvim";
  };
}
