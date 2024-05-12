{ inputs, outputs, config, lib, pkgs, ... }:
{
  services.minecraft-server = {
    enable = true;
    eula = true;
    package = pkgs.papermc;
    declarative = true;
    openFirewall = true;
    whitelist = {
      "74k1" = "18896095-fccb-464c-9cf5-2c23bd15616c";
      #moshimochi107 = "";
    };
    serverProperties = {
      server-port = 43000;
      max-players = 2;
      motd = "NixOS Minecraft server!";
      white-list = true;
    };
  };
}
