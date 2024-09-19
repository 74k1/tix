{ config, lib, pkgs, ... }:
{
  # Git Server
  services = {
    forgejo = {
      enable = true;
      package = pkgs.forgejo;
      settings = {
        service = {
          DISABLE_REGISTRATION = true;
          ENABLE_REVERSE_PROXY_AUTHENTICATION = true;
        };
        server = {
          DOMAIN = "git.example.com";
          ROOT_URL = "https://git.example.com/";
        };
        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };
      };
    };
    # Runner
    gitea-actions-runner = {
      package = pkgs.forgejo-actions-runner;
      instances.default = {
        enable = true;
        name = "monolith";
        url = "https://git.example.com";
        tokenFile = "/tmp/forgejo-runner-token";
        labels = [
          "ubuntu-latest:docker://node:16-bullseye"
          "ubuntu-22.04:docker://node:16-bullseye"
          "ubuntu-20.04:docker://node:16-bullseye"
          "ubuntu-18.04:docker://node:16-buster"
          # "native:host"
        ];
      };
    };
  };

}
