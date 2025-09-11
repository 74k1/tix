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
    extest.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
