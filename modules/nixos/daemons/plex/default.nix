{
  config,
  lib,
  pkgs,
  ...
}:
{
  # PLEX
  # hardware.graphics = {
  # enable = true;
  # driSupport = true;
  # driSupport32Bit = true;
  #   extraPackages = with pkgs; [
  #     libva-vdpau-driver
  #     libvdpau-va-gl
  #     # mesa
  #     vulkan-loader
  #     # nvidia-vaapi-driver
  #   ];
  # };

  # environment.variables = {
  #   "VDPAU_DRIVER" = "radeonsi";
  #   "LIBVA_DRIVER_NAME" = "radeonsi";
  # };

  services = {
    plex = {
      enable = true;
      package = pkgs.master.plex;
      dataDir = "/var/lib/plex";
      accelerationDevices = [ "*" ];
    };
    # tautulli.enable = true;
  };

  users.users.plex = {
    extraGroups = [ "render" "video" ];
  };

  # systemd.services.plex.serviceConfig = let
  #   pidFile = "${config.services.plex.dataDir}/Plex Media Server/plexmediaserver.pid";
  # in {
  #   KillSignal = lib.mkForce "SIGKILL";
  #   Restart = lib.mkForce "no";
  #   TimeoutStopSec = 10;
  #   ExecStop = pkgs.writeShellScript "plex-stop" ''
  #     ${pkgs.procps}/bin/pkill --signal 15 --pidfile "${pidFile}"
  #
  #     # Wait until plex service has been shutdown
  #     # by checking if the PID file is gone
  #     while [ -e "${pidFile}" ]; do
  #       sleep 0.1
  #     done
  #
  #     ${pkgs.coreutils}/bin/echo "Plex shutdown successful"
  #   '';
  #   PIDFile = lib.mkForce "";
  # };
}
