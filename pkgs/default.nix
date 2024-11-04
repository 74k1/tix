{ pkgs, ... }:
{
  duvolbr = pkgs.callPackage ./duvolbr.nix { };
  berkeley-ttf = pkgs.callPackage ./berkeley-ttf.nix { };
  git-email-filter = pkgs.callPackage ./git-email-filter.nix { };
}
