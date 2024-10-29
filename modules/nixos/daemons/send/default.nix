{ inputs, outputs, config, lib, pkgs, ... }:
{
  imports = [
    "${inputs.nixpkgs-master}/nixos/modules/services/web-servers/send.nix"
  ];

  services.send = {
    enable = true;
    package = inputs.nixpkgs-master.outputs.legacyPackages.x86_64-linux.send;
    environment = {
      "BASE_URL" = "https://send.example.com/";
      "PORT" = "107";
      "MAX_FILE_SIZE" = "10737418240"; # 10GB
      "DEFAULT_DOWNLOADS" = "2";
      "CUSTOM_DESCRIPTION" = "Encrypt and send files with a link that automatically expires.";
      "SEND_FOOTER_CLI_URL" = "";
      "SEND_FOOTER_SOURCE_URL" = "";
    };
    host = "0.0.0.0";
    port = 1444;
  };
  # virtualisation.arion = {
  #   backend = "docker";
  #   projects."send-redis".settings.services."send-redis".service = {
  #     image = "redis:alpine";
  #     restart = "unless-stopped";
  #     #command = "redis-server --save 20 1 --loglevel warning --requirepass oFSQJrEnHq2FoDz7W7Fp";
  #     volumes = [
  #       "/var/lib/send-redis/:/data"
  #       "/etc/localtime:/etc/localtime:ro"
  #     ];
  #     ports = [
  #       "6379:6379"
  #     ];
  #   };
  #   projects."send".settings.services."send".service = {
  #     image = "registry.gitlab.com/timvisee/send:latest";
  #     restart = "unless-stopped";
  #     environment = {
  #       BASE_URL = "https://send.example.com/";
  #       PORT = "80";
  #       MAX_FILE_SIZE = "10737418240"; # 10GB
  #       DEFAULT_DOWNLOADS = "2";
  #       FILE_DIR = "/uploads";
  #       REDIS_HOST = "127.0.0.1:6379";
  #       CUSTOM_DESCRIPTION = "Encrypt and send files with a link that automatically expires.";
  #       SEND_FOOTER_CLI_URL = "";
  #       SEND_FOOTER_SOURCE_URL = "";
  #     };
  #   };
  # };
}
