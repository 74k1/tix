{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.sonarr-alt;
in
{
  options = {
    services.sonarr-alt = {
      enable = mkEnableOption "Sonarr-alt";

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/sonarr-alt/.config/NzbDrone";
        description = "The directory where Sonarr-alt stores its data files.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the Sonarr-alt web interface
        '';
      };

      user = mkOption {
        type = types.str;
        default = "sonarr-alt";
        description = "User account under which Sonarr-alt runs.";
      };

      group = mkOption {
        type = types.str;
        default = "sonarr-alt";
        description = "Group under which Sonarr-alt runs.";
      };

      package = mkPackageOption pkgs "sonarr" { };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.sonarr-alt = {
      description = "Sonarr-alt";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/NzbDrone -nobrowser -data='${cfg.dataDir}'";
        Restart = "on-failure";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 8989 ];
    };

    users.users = mkIf (cfg.user == "sonarr-alt") {
      sonarr-alt = {
        group = cfg.group;
        home = cfg.dataDir;
        uid = 276;
      };
    };

    users.groups = mkIf (cfg.group == "sonarr-alt") {
      sonarr-alt.gid = 276;
    };
  };
}
