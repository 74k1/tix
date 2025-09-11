{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "vaapi";
      vo = "gpu-next";
      video-sync = "display-resample";
      framedrop = "decoder+vo";
    };
  };
}
