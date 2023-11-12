{ config, lib, pkgs, ...}:

{
  xsession.windowManager.bspwm = {
    enable = true;
    package = pkgs.bspwm;
    # extraConfig = builtins.readFile ./bspwmrc;
    extraConfig = ''
      #!/bin/sh

      # number of workspaces
      bspc monitor DP-2 -d ♔ ♕ ♖ ♘ ♗ ♙
      bspc monitor DP-0 -d ♚ ♛ ♜ ♞ ♝ ♟︎ 
      
      # window config
      bspc config border_width 2
      bspc config window_gap 15
      bspc config split_ratio 0.50
      bspc config borderless_monocle true
      bspc config gapless_monocle true
      bspc config focus_follows_pointer true
      bspc config click_to_focus true
      bspc config initial_polarity second_child
      
      # padding outside of window
      bspc config top_padding 50
      bspc config bottom_padding 25
      bspc config left_padding 25
      bspc config right_padding 25
      
      # colors
      bspc config focused_border_color "#${config.colorScheme.colors.base02}"
      bspc config normal_border_color "#${config.colorScheme.colors.base00}"
      bspc config active_border_color "#${config.colorScheme.colors.base00}"
      bspc config presel_feedback_color "#${config.colorScheme.colors.base08}"
      
      # rules
      #bspc desktop ^2 -l monocle
      bspc rule -a Discord desktop=^5
      bspc rule -a Spotify desktop=^6
      
      # floating windows
      ## move floating windows
      bspc config pointer_action1 move
      
      ## resize floating windows
      bspc config pointer_action2 resize_side
      bspc config pointer_action2 resize_corner
      
      ## floating windows
      #bspc rule -a vlc desktop='^4' follow=on
      #bspc rule -a KeePassXC state=floating center=true rectangle=909x625+0+0
      bspc rule -a feh state=floating center=true
      #bspc rule -a galculator state=floating
      
      # Autostart apps
      ## keybindings daemon
      pgrep -x sxhkd > /dev/null || sxhkd &
      systemctl --user restart polybar.service &
    '';
  };
}
