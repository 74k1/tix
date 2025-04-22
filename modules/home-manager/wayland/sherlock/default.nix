{ inputs, outputs, config, lib, pkgs, ... }: {

  # disabledModules = [ "programs/sherlock.nix" ];
  #
  # imports = [
  #   inputs.sherlock.homeManagerModules.default
  # ];
  #
  programs.sherlock = {
    enable = true;

    # for faster startup times
    systemd.enable = true;

    package = inputs.sherlock.packages.${pkgs.system}.default;

    # config.json / config.toml
    settings = {};

    # sherlock_alias.json
    # aliases = {
    #   vesktop = { name = "Discord"; };
    # };

    # sherlockignore
    # ignore = ''
    #   Avahi*
    # '';

    # fallback.json
    launchers = [
      {
        name = "Calculator";
        type = "calculation";
        args = {
          capabilities = [
            "calc.math"
            "calc.units"
          ];
        };
        priority = 1;
      }
      {
        name = "App Launcher";
        type = "app_launcher";
        args = {};
        priority = 2;
        home = "Home";
      }
    ];

    # main.css
    style = /* css */ ''
      * {
        font-family: "PP Supply Mono";
      }
    '';
  };
}
