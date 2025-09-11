{
  allSecrets,
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.braindump.nixosModules.default
  ];

  age.secrets."braindump_ssh_key" = {
    rekeyFile = "${inputs.self}/secrets/braindump_ssh_key.age";
    # mode = "770";
    # owner = "braindump";
    # group = "braindump";
  };

  services.braindump = {
    enable = true;
    port = 8677;
    dumpPath = "/var/lib/braindump/journal";
    dayCutoffHour = 4;

    gitRemote = "ssh://forge@git.yukume.com/74k1/journal.git";

    git = {
      userName = allSecrets.global.me.git.user.name;
      userEmail = allSecrets.global.me.git.user.email;
      sshKeyFile = config.age.secrets."braindump_ssh_key".path;
    };
  };
}
