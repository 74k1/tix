{ config, lib, pkgs, ... }:

let
  cfg = config.services.librechat;
in {
  options.services.librechat = {
    enable = lib.mkEnableOption "LibreChat service";
    
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage "${inputs.self}/pkgs/librechat.nix" { inherit pkgs; };
      description = "LibreChat package to use";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "librechat";
      description = "User under which LibreChat runs";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "librechat";
      description = "Group under which LibreChat runs";
    };

    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/librechat";
      description = "Directory for LibreChat state files";
    };

    mongodbDatabase = lib.mkOption {
      type = lib.types.str;
      default = "librechat";
      description = "MongoDB database name";
    };
  };

  config = lib.mkIf cfg.enable {
    services.mongodb = {
      enable = true;
      bind_ip = "127.0.0.1";
      quiet = true;
      extraConfig = ''
        storage:
          dbPath: "${cfg.stateDir}/mongodb"
      '';
    };

    systemd.services.librechat = {
      description = "LibreChat Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "mongodb.service" ];
      requires = [ "mongodb.service" ];

      environment = {
        MONGO_URI = "mongodb://127.0.0.1:27017/${cfg.mongodbDatabase}";
        NODE_ENV = "production";
      };

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "librechat";
        StateDirectoryMode = "0750";
        ExecStart = "${cfg.package}/bin/librechat";
        Restart = "always";
        RestartSec = "10";
        WorkingDirectory = "${cfg.package}/lib/librechat";
      };
    };

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.stateDir;
      createHome = true;
      description = "LibreChat service user";
    };

    users.groups.${cfg.group} = {};
  };
}
