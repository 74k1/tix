{ config, lib, pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "d /var/lib/authelia 0755 authelia authelia -"
  ];
  services.authelia = {
    instances.yukume = {
      enable = true;
      secrets = {
        storageEncryptionKeyFile = "/var/lib/authelia-yukume/authelia_storageEncKeyFile_secret";
        jwtSecretFile = "/var/lib/authelia-yukume/authelia_jwt_secret";
      };
      settings = {
        theme = "dark";
        default_2fa_method = "totp";
        server = {
          port = 9091;
          host = "0.0.0.0";
        };
        authentication_backend.file = {
          path = "/var/lib/authelia/users_db.yml";
          watch = false;
          search = {
            email = false;
            case_insensitive = false;
          };
          password = {
            algorithm = "argon2";
            argon2 = {
              variant = "argon2id";
              iterations = 3;
              memory = 65536;
              parallelism = 4;
              key_length = 32;
              salt_length = 16;
            };
          };
        };
        access_control.default_policy = "two_factor";
        access_control.rules = [
          { domain = "*"; policy = "two_factor"; }
        ];
        session.domain = "example.com";
        storage.local.path = "/var/lib/authelia/db.sqlite3";
        notifier.filesystem.filename = "/var/lib/authelia/notif";
        log.level = "debug";
      };
    };
  };
}
