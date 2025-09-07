{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Fail2Ban
  services.fail2ban = {
    enable = true;
    maxretry = 3;
    bantime = "30m";
    bantime-increment = {
      enable = true;
      rndtime = "8m";
      overalljails = true;
      multipliers = "1 2 4 8 16 32 64 128";
      maxtime = "72h";
      factor = "4";
    };
  };
}
