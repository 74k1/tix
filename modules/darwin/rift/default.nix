# rift (https://github.com/acsandmann/rift) — tiling wm for macos.
#
# upstream nix-darwin has no rift module, so this is a small local one.
# the settings below are serialized with pkgs.formats.toml and land in two
# places:
#   - a nix store file the launchd agent runs as `rift --config <path>`.
#     any settings change => new service definition => launchd restarts rift
#     with the new config, so `darwin-rebuild switch` "just applies".
#   - mirrored to ~/.config/rift/config.toml at activation (tooling that
#     reads the documented default path: rift-cli config save, the
#     ui.menu_bar layout_folder default, etc). an existing real file there
#     gets overwritten — the nix config is the source of truth.
#
# structure follows https://github.com/acsandmann/rift/wiki/Config and
# rift.default.toml: per-section nix options instead of one flat blob.
#   services.rift.settings             -> [settings]
#   services.rift.virtualWorkspaces    -> [virtual_workspaces]
#                                         (workspace_names, app_rules and
#                                         workspace_rules are nested in here)
#   services.rift.modifierCombinations -> [modifier_combinations]
#   services.rift.keys                 -> [keys]
# omitted sections/keys just keep rift's built-in defaults. don't set options
# to null to "unset" — types.toml rejects nulls; just leave the key out.
#
# note: first launch triggers the macOS accessibility permission prompt;
# grant it manually (system settings -> privacy & security -> accessibility)
# or rift can't see/manipulate windows.

{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.services.rift;

  tomlFmt = pkgs.formats.toml { };

  # the four sections are independent top-level toml tables; formats.toml
  # handles the rest (quoted keys for "Alt + H", floats, arrays of tables,
  # escaping)
  configToml = tomlFmt.generate "rift-config.toml" {
    settings = cfg.settings;
    virtual_workspaces = cfg.virtualWorkspaces;
    modifier_combinations = cfg.modifierCombinations;
    keys = cfg.keys;
  };
in

{
  options.services.rift = {
    enable = lib.mkEnableOption "rift, a tiling window manager for macOS";

    package = lib.mkPackageOption pkgs "rift-wm" { };

    user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        User whose home gets the config mirrored to ~/.config/rift/config.toml.
        Defaults to {option}`system.primaryUser` when that is set.
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.package;
      default = configToml;
      defaultText = lib.literalExpression "generated config.toml";
      description = ''
        The generated config the launchd agent runs with. Inspect with
        `nix build .#darwinConfigurations.chisa.config.services.rift.configFile`.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = tomlFmt.type;
        options.run_on_start = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = ''
            Shell commands rift runs at startup (event subscriptions etc).
            Other modules (e.g. the sketchybar integration) append to this.
          '';
        };
      };
      default = { };
      description = "The [settings] table of config.toml";
    };

    virtualWorkspaces = lib.mkOption {
      type = tomlFmt.type;
      default = { };
      description = "The [virtual_workspaces] table (incl. workspace_names, app_rules, workspace_rules)";
    };

    modifierCombinations = lib.mkOption {
      type = tomlFmt.type;
      default = { };
      description = "The [modifier_combinations] table";
    };

    keys = lib.mkOption {
      type = tomlFmt.type;
      default = { };
      description = ''
        The [keys] table, e.g.
        keys."Alt + H" = {{ move_focus = "left"; }};
      '';
    };
  };

  # NOTE: hosts enable this via services.rift.enable = true; (setting it here
  # under mkIf cfg.enable would be an infinite recursion)
  config = lib.mkIf cfg.enable {
    services.rift.user = lib.mkIf (config.system.primaryUser != null) config.system.primaryUser;

    services.rift = {
      settings = {
        animate = true;
        animation_duration = 0.3;
        animation_fps = 100.0;

        focus_follows_mouse = true;
        mouse_follows_focus = true;
        mouse_hides_on_focus = true;

        # keep system stuff (and launchers) from stealing focus / switching workspaces
        auto_focus_blacklist = [
          "com.apple.dock"
          "com.apple.systemuiserver"
          "com.apple.SecurityAgent"
          "com.raycast.macos"
          "com.apple.Spotlight"
        ];

        # the sketchybar module appends its rift event subscriptions to this
        run_on_start = [ ];

        # watches the config file rift was started with; since that's the
        # immutable store copy, config changes apply via darwin-rebuild
        # (the service definition changes, launchd restarts rift)
        hot_reload = true;

        # rift defaults for the rest; add more here, e.g.
        #   virtualWorkspaces.default_workspace_count = 6;
        #   keys."Alt + H" = { move_focus = "left"; };
      };
    };

    # rift + rift-cli available in terminals
    environment.systemPackages = [ cfg.package ];

    launchd.user.agents.rift = {
      serviceConfig = {
        ProgramArguments = [
          (lib.getExe cfg.package)
          "--config"
          "${configToml}"
        ];
        KeepAlive = true;
        RunAtLoad = true;
        # only load in the graphical session, and treat it as interactive
        # (a wm reacts to input all day, don't let macOS throttle it)
        LimitLoadToSessionType = "Aqua";
        ProcessType = "Interactive";
      };
      managedBy = "services.rift.enable";
    };

    system.activationScripts.riftConfig.text = lib.mkIf (cfg.user != null) ''
      # mirror the declarative rift config to the documented default path
      # (the launchd agent runs --config against the store copy instead,
      # so hot_reload never fights the activation)
      mkdir -p "/Users/${cfg.user}/.config/rift"
      install -m 0644 -o ${cfg.user} -g staff "${configToml}" "/Users/${cfg.user}/.config/rift/config.toml"
    '';
  };
}
