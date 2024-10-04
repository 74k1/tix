{ inputs, outputs, config, lib, pkgs, ... }:
{
  age.secrets."forgejo_runner_token" = {
    rekeyFile = "${inputs.self}/secrets/forgejo_runer_token.age";
    mode = "770";
    owner = "forgejo";
    group = "forgejo";
  };
  # Git Server
  services = {
    forgejo = {
      enable = true;
      package = pkgs.forgejo;
      lfs.enable = true;
      settings = {
        service = {
          DISABLE_REGISTRATION = true;
          ENABLE_REVERSE_PROXY_AUTHENTICATION = true;
        };
        server = {
          DOMAIN = "git.example.com";
          ROOT_URL = "https://git.example.com/";
          SSH_PORT = 727;
          START_SSH_SERVER = true;
          SSH_SERVER_USE_PROXY_PROTOCOL = true;

        };
        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };
      };
    };
    # Runner
    # gitea-actions-runner = {
    #   package = pkgs.forgejo-actions-runner;
    #   instances.default = {
    #     enable = true;
    #     name = "monolith";
    #     url = "https://git.example.com";
    #     #tokenFile = "/tmp/forgejo-runner-token";
    #     tokenFile = config.age.secrets."forgejo_runner_token".path;
    #     labels = [
    #       "ubuntu-latest:docker://node:16-bullseye"
    #       "ubuntu-22.04:docker://node:16-bullseye"
    #       "ubuntu-20.04:docker://node:16-bullseye"
    #       "ubuntu-18.04:docker://node:16-buster"
    #       # "native:host"
    #     ];
    #   };
    # };
  };

}
