{ inputs, outputs, config, lib, pkgs, allSecrets, ... }:
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
          DOMAIN = "git.${allSecrets.global.domain0}";
          ROOT_URL = "https://git.${allSecrets.global.domain0}/";
          SSH_PORT = 2277;
          START_SSH_SERVER = true;
          SSH_DOMAIN = "git.${allSecrets.global.domain0}";
          SSH_SERVER_USE_PROXY_PROTOCOL = true;
        };
        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };
      };
    };
    openssh.settings.AcceptEnv = "GIT_PROTOCOL";
    # Runner
    # gitea-actions-runner = {
    #   package = pkgs.forgejo-actions-runner;
    #   instances.default = {
    #     enable = true;
    #     name = "monolith";
    #     url = "https://git.${allSecrets.global.domain0}";
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
