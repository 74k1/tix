{ pkgs, ... }:
{
  duvolbr = pkgs.callPackage ./duvolbr.nix { };
  berkeley-ttf = pkgs.callPackage ./berkeley-ttf.nix { };
  lumen = pkgs.callPackage ./lumen.nix { };
}
