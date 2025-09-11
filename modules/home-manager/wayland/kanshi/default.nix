{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  services.kanshi = {
    enable = true;
    # no process seems to start with niri-session.target.
    # workaround: `(kanshi &) && kanshictl switch external`
    systemdTarget = "graphical-session.target";
    settings = [
      {
        output = {
          adaptiveSync = false;
          criteria = "eDP-1";
          mode = "1600x2560@144";
          scale = 1.75;
          transform = "270";
        };
      }
      {
        profile = {
          name = "undocked";
          exec = [
            "${lib.getExe pkgs.swww} restore"
          ];
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
            }
          ];
        };
      }
      {
        profile = {
          name = "docked_home";
          exec = [
            "${lib.getExe pkgs.swww} restore"
          ];
          outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              adaptiveSync = false;
              criteria = "PNP(AOC) AG276QZD2 2OMQ8JA002044";
              mode = "2560x1440@240.000";
              position = "1080,0";
              scale = 1.0;
              status = "enable";
            }
            {
              adaptiveSync = false;
              criteria = "ASUSTek COMPUTER INC MQ16AHE S8LMTF100577";
              mode = "1920x1080@60.000";
              position = "0,0";
              scale = 1.0;
              status = "enable";
              transform = "90";
            }
          ];
        };
      }
      {
        profile = {
          name = "docked_mobile";
          exec = [
            "${lib.getExe pkgs.swww} restore"
          ];
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
            }
            {
              adaptiveSync = false;
              criteria = "ASUSTek COMPUTER INC MQ16AHE S8LMTF100577";
              mode = "1920x1080@60.000";
              position = "-1080,0";
              scale = 1.0;
              status = "enable";
              transform = "normal";
            }
          ];
        };
      }
      # {
      #   profile = {
      #     name = "docked_work";
      #     exec = [ "${lib.getExe pkgs.swww} restore" ];
      #     outputs = [
      #       {
      #         criteria = "eDP-1";
      #         status = "disable";
      #       }
      #       {
      #         adaptiveSync = false;
      #         criteria = "DP-2";
      #         # mode = "2560x1440@240.000";
      #         position = "0,0";
      #         scale = 1.0;
      #         status = "enable";
      #       }
      #     ];
      #   };
      # }
    ];
  };
}
