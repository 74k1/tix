{
  bash = import ./shell/bash;
  bspwm = import ./x11/bspwm;
  colors = import ./x11/colors;
  git = import ./shell/git;
  hyprland = import ./wayland/hyprland;
  waybar = import ./wayland/waybar;
  i3wm = import ./x11/i3wm;
  nvim = import ./shell/nvim;
  picom = import ./x11/picom;
  polybar = import ./apps/polybar;
  rofi = import ./apps/rofi;
  spotify = import ./apps/spotify;
  starship = import ./shell/starship;
  style = import ./stylix.nix;
  sxhkd = import ./x11/sxhkd;
  theme = import ./x11/theme;
  wall = import ./x11/wall;
  wezterm = import ./apps/wezterm;
  wired = import ./apps/wired;
  xdg = import ./x11/xdg;
  xorg = import ./x11/xorg;
  zsh = import ./shell/zsh;
}
