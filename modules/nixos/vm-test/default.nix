{ config, lib, pkgs, ... }:

{
  # VM shenanigans
  virtualisation.vmVariant = {
    users = {
      mutableUsers = false;
      users =
        lib.pipe
          config.users.users
          [
            (lib.filterAttrs
              (user: config:
                config.isNormalUser
              )
            )
            (lib.mapAttrs
              (user: _:
                { password = "foo"; }
              )
            )
          ];
    };
  };
}
