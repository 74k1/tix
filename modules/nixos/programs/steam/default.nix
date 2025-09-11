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
  ];
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
