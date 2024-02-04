{ config, lib, pkgs, ... }:
{
  services = {
    n8n = {
      enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    nodejs
  ];
  programs.npm.enable = true;
}
