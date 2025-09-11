{
  config,
  inputs,
  pkgs,
  self,
  ...
}:
{
  environment.systemPackages = [
    pkgs.gamescope
    pkgs.apple-cursor
  ];
  programs.steam = {
    enable = true;
    extest.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  xdg.icons.fallbackCursorThemes = [ "apple_cursor" ];
}
