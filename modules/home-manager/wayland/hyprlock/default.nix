{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 0;
        hide_cursor = true;
        immediate_render = true;
        no_fade_in = true;
        no_fade_out = true;
      };

      background = lib.mkForce [
        {
          monitor = "";
          path = lib.mkForce "/home/taki/docs/opencloud/Personal/I. Personal/III. Resources/Images/Wallpaper/2026/01/darkened.jpg";
          blur_passes = 2;
          # blur_size = 15;
          noise = "0.2";
          contrast = "1.2";
          brightness = "0.2";
          vibrancy = "0.4";
          vibrancy_darkness = "0.4";
        }
      ];

      input-field = lib.mkForce [
        {
          monitor = "";

          size = "256, 48";
          valign = "center";
          halign = "center";
          position = "0, -5%";
          rounding = 0;

          outline_thickness = 1;

          font_color = lib.mkForce "rgba(235, 233, 241, 0.8)";
          outer_color = lib.mkForce "rgba(50, 50, 70, 0)";
          inner_color = lib.mkForce "rgba(7, 6, 11, 0)";
          check_color = lib.mkForce "rgba(129, 107, 255, 1)";
          fail_color = lib.mkForce "rgba(255, 84, 135, 1)";

          placeholder_text = "Enter Password";
          hide_input = false;

          dots_spacing = 0.2;
          dots_center = true;
          dots_fade_time = 0;

          shadow_color = lib.mkForce "#07060B";
          shadow_size = 0;
          shadow_passes = 1;
        }
      ];

      label = lib.mkForce [
        {
          monitor = "";
          text = ''
            cmd[update:60000] date +"%H:%M"
          '';
          font_size = 144;
          font_family = "Poltawski Nowy Regular";
          color = "rgba(235, 233, 241, 0.6)";

          position = "0%, 10%";

          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = ''
            cmd[update:60000] date +"%A, %d %b %Y"
          '';
          font_size = 48;
          font_family = "PP Supply Mono";
          color = "rgba(235, 233, 241, 0.2)";

          position = "0%, 0%";

          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
