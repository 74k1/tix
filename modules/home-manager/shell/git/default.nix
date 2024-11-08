{ config, inputs, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "74k1";
    userEmail = "git.t@betsumei.com";
    extraConfig.core.editor = "nvim";
  };
}
