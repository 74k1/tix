{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  allSecrets,
  ...
}:
{
  age.secrets."forgejo_runner_token" = {
    rekeyFile = "${inputs.self}/secrets/forgejo_runner_token.age";
    # mode = "770";
    # owner = "forgejo";
    # group = "forgejo";
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
          ENABLE_BASIC_AUTHENTICATION = false;
        };
        server = {
          DOMAIN = "git.${allSecrets.global.domain0}";
          ROOT_URL = "https://git.${allSecrets.global.domain0}/";
          SSH_PORT = 22;
          START_SSH_SERVER = true;
          SSH_DOMAIN = "git.${allSecrets.global.domain0}";
          SSH_SERVER_USE_PROXY_PROTOCOL = true;
          BUILTIN_SSH_SERVER_USER = "forge";
          SSH_LISTEN_PORT = 2277;
        };
        mailer = {
          ENABLED = true;
          PROTOCOL = "smtp+starttls";
          SMTP_ADDR = allSecrets.global.mail.sender.host;
          SMTP_PORT = allSecrets.global.mail.sender.port;
          USER = allSecrets.global.mail.sender.username;
          PASSWD = allSecrets.global.mail.sender.password;
          FROM = "\"[SYSTEM] Forgejo\"<${allSecrets.global.mail.sender.username}>";
        };
        actions = {
          ENABLED = true;
          DEFAULT_ACTIONS_URL = "github";
        };
        ui = {
          SHOW_USER_EMAIL = false;
        };
      };
    };
    openssh.settings.AcceptEnv = "GIT_PROTOCOL";
    # Runner
    gitea-actions-runner = {
      package = pkgs.forgejo-runner;
      instances.default = {
        enable = true;
        name = "monolith";
        url = "https://git.${allSecrets.global.domain0}";
        #tokenFile = "/tmp/forgejo-runner-token";
        tokenFile = config.age.secrets."forgejo_runner_token".path;
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
