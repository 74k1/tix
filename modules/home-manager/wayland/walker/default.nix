{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.walker
    pkgs.libqalculate
  ];

  systemd.user.services.walker = {
    Unit.Description = "Walker - App Launcher";
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${lib.getExe pkgs.walker} --gapplication-service";
      Restart = "on-failure";
    };
  };
}
