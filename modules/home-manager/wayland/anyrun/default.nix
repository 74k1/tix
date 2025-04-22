{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: {
  imports = [
    # inputs.anyrun.homeManagerModules.default
  ];

  programs.anyrun = {
    enable = true;
    config = {
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      width = { fraction = 0.3; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = null;

      plugins = [
        inputs.anyrun.packages.${pkgs.system}.applications
        inputs.anyrun.packages.${pkgs.system}.rink
        inputs.anyrun.packages.${pkgs.system}.stdin
        # ./some_plugin.so
        # "${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/kidex"
        inputs.anyrun-nixos-options.packages.${pkgs.system}.default
      ];
    };

    extraCss = /* css */ ''
      /* GTK Vars */
      @define-color bg-color #313244;
      @define-color fg-color #cdd6f4;
      @define-color primary-color #89b4fa;
      @define-color secondary-color #cba6f7;
      @define-color border-color @primary-color;
      @define-color selected-bg-color @primary-color;
      @define-color selected-fg-color @bg-color;

      * {
        all: unset;
        font-family: "PP Supply Mono";
      }

      #window {
        background: transparent;
      }

      box#main {
        border-radius: 8px;
        background-color: alpha(@bg-color, 0.6);
        border: 0.5px solid alpha(@fg-color, 0.25);
      }

      entry#entry {
        font-size: 1.25rem;
        background: transparent;
        box-shadow: none;
        border: none;
        /* border-radius: 8px; */
        padding: 16px 24px;
        min-height: 40px;
        caret-color: @primary-color;
      }

      list#main {
        background-color: transparent;
      }

      #plugin {
        background-color: transparent;
        padding-bottom: 4px;
      }

      #match {
        font-size: 1rem;
        padding: 2px 4px;
      }

      #match:selected,
      #match:hover {
        border-radius: 8px 0 0 8px;
        background-color: @selected-bg-color;
        color: @selected-fg-color;
      }

      #match:selected label#info,
      #match:hover label#info {
        color: @selected-fg-color;
      }

      #match:selected label#match-desc,
      #match:hover label#match-desc {
        color: alpha(@selected-fg-color, 0.9);
      }

      #match label#info {
        color: transparent;
        color: @fg-color;
      }

      label#match-desc {
        font-size: 1rem;
        color: @fg-color;
      }

      /* label#plugin { */
      /*   font-size: 16px; */
      /* } */
    '';

    extraConfigFiles."nixos-options.ron".text = let
        #               ↓ home-manager refers to the nixos configuration as osConfig
        nixos-options = osConfig.system.build.manual.optionsJSON + "/share/doc/nixos/options.json";
        # or alternatively if you wish to read any other documentation options, such as home-manager
        # get the docs-json package from the home-manager flake
        hm-options = inputs.home-manager.packages.${pkgs.system}.docs-json + "/share/doc/home-manager/options.json";
        options = builtins.toJSON {
          ":nix" = [nixos-options];
          ":hm" = [hm-options];
          ":mn" = [nixos-options hm-options];
        };
    in /* ron */ ''
    Config(
        options: ${options},
      )
    '';
  };
}
