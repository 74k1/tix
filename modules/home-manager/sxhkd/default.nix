{ config, lib, pkgs, ... }:

let
  mod = "super";
  alt = "alt";
in
{
  services.sxhkd = {
    enable = true;
    package = pkgs.sxhkd;

    # extraConfig = builtins.readFile ./sxhkdrc;
    keybindings = {
      # term
      "Control_L + ${alt} + t" = "${pkgs.wezterm}/bin/wezterm";
      "${mod} + Return" = "${pkgs.wezterm}/bin/wezterm";

      # rofi
      "${mod} + space" = "${pkgs.rofi}/bin/rofi -config -no-lazy-grab -show drun -modi drun";
      "${mod} + r" = "${pkgs.rofi}/bin/rofi -config -no-lazy-grab -show drun -modi drun";

      # alt-tab
      "${alt} + Tab" = "${pkgs.rofi}/bin/rofi -kb-accept-entry '!Alt-Tab' -kb-row-down Alt-Tab -show window";
      
      # scrot
      "Print" = "sh -e -c '${pkgs.shotgun}/bin/shotgun $(${pkgs.slop}/bin/slop -l -c 0.3,0.4,0.6,0.4 -f \"-i %i -g %g\") - | ${pkgs.xclip}/bin/xclip -selection clipboard -t \"image/png\"'";
      "${mod} + x" = "sh -e -c '${pkgs.shotgun}/bin/shotgun $(${pkgs.slop}/bin/slop -l -c 0.3,0.4,0.6,0.4 -f \"-i %i -g %g\") - | ${pkgs.xclip}/bin/xclip -selection clipboard -t \"image/png\"'";
      # Mac-like Keybind :^)
      "${alt} + Shift + s" = "sh -e -c '${pkgs.shotgun}/bin/shotgun $(${pkgs.slop}/bin/slop -l -c 0.3,0.4,0.6,0.4 -f \\\\\"-i %i -g %g\\\\\") - | ${pkgs.xclip}/bin/xclip -selection clipboard -t \\\\\"image/png\\\\\"'";

      # close window
      "${alt} + F4" = "bspc node --close";

      # Multimedia Hotkeys
      # pactl & playerctl # without script
      #"XF86AudioRaiseVolume" = "${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 +5%";
      #"XF86AudioLowerVolume" = "${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 -5%";
      #"XF86AudioMute" = "${pkgs.pulseaudio}/bin/pactl set-sink-mute 0 toggle";
      #"XF86MonBrightnessUp" = "${pkgs.xorg.xbacklight}/bin/xbacklight -inc 5";
      #"XF86MonBrightnessDown" = "${pkgs.xorg.xbacklight}/bin/xbacklight -dec 5";
      #"XF86AudioPlay" = "${pkgs.playerctl}/bin/playerctl play-pause";
      #"XF86AudioPause" = "${pkgs.playerctl}/bin/playerctl pause";
      #"XF86AudioNext" = "${pkgs.playerctl}/bin/playerctl next";
      #"XF86AudioPrev" = "${pkgs.playerctl}/bin/playerctl previous";

      # pactl & playerctl # with script
      "XF86AudioRaiseVolume" = "${pkgs.duvolbr}/bin/duvolbr vol_up";
      "XF86AudioLowerVolume" = "${pkgs.duvolbr}/bin/duvolbr vol_down";
      "XF86AudioMute" = "${pkgs.duvolbr}/bin/duvolbr vol_mute";
      #"XF86MonBrightnessUp" = "${pkgs.duvolbr}/bin/duvolbr bri_up";
      #"XF86MonBrightnessDown" = "${pkgs.duvolbr} bri_down";
      "XF86AudioPlay" = "${pkgs.duvolbr}/bin/duvbolbr play_pause";
      "XF86AudioPause" = "${pkgs.duvolbr}/bin/duvolbr play_pause";
      "XF86AudioNext" = "${pkgs.duvolbr}/bin/duvolbr next_track";
      "XF86AudioPrev" = "${pkgs.duvolbr}/bin/duvolbr prev_track";
    };
  };
}
