{
  config,
  lib,
  pkgs,
  ...
}:
let
  plexFixed = pkgs.master.plex.override {
    plexRaw = pkgs.master.plexRaw.overrideAttrs (old: rec {


      version = "1.43.1.10611-1e34174b1";

      src = pkgs.fetchurl {
        url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
        hash = "sha256-pr1+VSObX0sBl/AddeG/+2dIbNdc+EtnvCzy4nTXVn8=";
      };
    });
  };
in
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
      # package = pkgs.master.plex;
      package = plexFixed;
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
