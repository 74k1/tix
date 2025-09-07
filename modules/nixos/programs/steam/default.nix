{
  config,
  inputs,
  pkgs,
  self,
  ...
}:
{
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
