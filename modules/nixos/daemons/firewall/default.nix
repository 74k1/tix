{ config, lib, pkgs, ... }:
{
  networking.firewall.enable = true;
  environment.systemPackages = [ pkgs.nftables ];
}
