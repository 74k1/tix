{ pkgs, ... }:
{
  duvolbr = pkgs.callPackage ./duvolbr.nix { };
  berkeley-otf = pkgs.callPackage ./berkeley-otf.nix { };
}
