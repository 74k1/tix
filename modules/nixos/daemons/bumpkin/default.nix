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
  imports = [
    inputs.bumpkin.nixosModules.default
  ];

  age.secrets."bumpkin_forge_token" = {
    rekeyFile = "${inputs.self}/secrets/bumpkin_forge_token.age";
    # mode = "770";
    owner = "bumpkin";
    group = "bumpkin";
  };

  services.bumpkin = {
    enable = true;

    maintainers = [ "74k1" ]; # TODO: _74k1 once lib.maintainers merged

    packageSets = [
      {
        repo = "github:74k1/tixpkgs";
        noBuild = [
          "waterfox"
          "waterfox-unwrapped"
        ];
      }
    ];

    actions = {
      commit = true;
      signed = false;
      push = true;
      pr = true;
    };

    git = {
      userName = "74k2";
      userEmail = "git.74k2.t@betsumei.com";
    };

    forgeTokenFile = config.age.secrets."bumpkin_forge_token".path;

    schedule = "daily";
    gc.enable = true;
  };
}
