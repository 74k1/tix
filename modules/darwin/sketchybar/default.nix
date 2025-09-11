# sketchybar driven by rift: workspace indicators on the left (queried live
# from rift-cli, so one plugin updates everything), front-app + clock on the
# right. the rift -> sketchybar wiring happens by appending event
# subscriptions to services.rift.settings.run_on_start (guarded, so this
# module also works standalone — the bar just stays un-highlighted).
#
# see https://github.com/acsandmann/rift/wiki/Integrations#events-and-sketchybar
# and https://github.com/Kcraft059/sketchybar-config for the re-query pattern.

{
  pkgs,
  lib,
  config,
  options,
  ...
}:

let
  cfg = config.services.sketchybar;

  # how many rift workspace indicators to render. keep in sync with rift's
  # virtual_workspaces.default_workspace_count (rift default: 4)
  workspaceCount = 4;

  # tokyo-night-ish
  fg = "0xffa9b1d6";
  accent = "0xff7aa2f7";
  bg = "0xe01a1b26";
  border = "0xff3b4261";

  # workspace item updater. called on rift events, clicks and once at
  # startup. deliberately re-queries `rift-cli` instead of trusting event env
  # vars — the query is authoritative and one call updates every item, then
  # everything is pushed to sketchybar in a single --batch.
  riftSpaces = pkgs.writeShellScript "sketchybar-rift-spaces" ''
    # $1 = workspace index this item represents (used on mouse.clicked)
    state="$(rift-cli query workspaces 2>/dev/null | jq -r '"\(.is_active) \(.index) \(.windows | length)"')"
    [ -n "$state" ] || exit 0

    args=()
    while read -r active idx count; do
      if [ "$active" = "true" ]; then
        args+=(--set "space.$idx" background.drawing=on icon.highlight=on)
      else
        args+=(--set "space.$idx" background.drawing=off icon.highlight=off)
      fi
      if [ "$count" -gt 0 ]; then
        args+=(--set "space.$idx" label="$count" label.drawing=on)
      else
        args+=(--set "space.$idx" label.drawing=off)
      fi
    done < <(echo "$state" | sort -k2,2n)

    case "$SENDER" in
      mouse.clicked) rift-cli execute workspace switch "$1" >/dev/null 2>&1 ;;
    esac

    sketchybar --batch "''${args[@]}"
  '';

  frontApp = pkgs.writeShellScript "sketchybar-front-app" ''
    sketchybar --set "$NAME" label="''${INFO:-}"
  '';

  clock = pkgs.writeShellScript "sketchybar-clock" ''
    sketchybar --set "$NAME" label="$(date "+%a %d %b  %H:%M")"
  '';

  workspaceItems = lib.concatMapStringsSep "\n" (
    i:
    let
      idx = toString i;
    in
    ''  sketchybar --add item "space.${idx}" left \
    --set "space.${idx}" \
      icon="${toString (i + 1)}" \
      icon.padding_left=8 icon.padding_right=2 \
      label.padding_left=2 label.padding_right=8 \
      label.drawing=off \
      background.height=18 background.corner_radius=5 \
      background.color=${border} background.drawing=off \
      icon.highlight_color=${accent} \
      script="${riftSpaces} ${idx}" \
    --subscribe "space.${idx}" rift_workspace_changed rift_windows_changed mouse.clicked''
  ) (lib.range 0 (workspaceCount - 1));
in

{
  services.sketchybar = {
    enable = true;
    # jq: parse rift-cli output in the plugins; rift-wm: ships rift-cli
    extraPackages = [
      pkgs.jq
      pkgs.rift-wm
    ];
    config = ''
      ##### bar #####
      sketchybar --bar \
        height=26 \
        color=${bg} \
        border_width=1 \
        border_color=${border} \
        blur_radius=20 \
        corner_radius=8 \
        padding_left=6 padding_right=6

      sketchybar --default \
        icon.font="SF Pro:Semibold:13.0" \
        label.font="SF Pro:Regular:12.0" \
        icon.color=${fg} \
        label.color=${fg} \
        updates=when_shown

      ##### rift workspaces #####
      sketchybar --add event rift_workspace_changed
      sketchybar --add event rift_windows_changed

${workspaceItems}

      ##### right side #####
      sketchybar --add item front_app right \
        --set front_app \
          label.padding_right=10 \
          script="${frontApp}" \
        --subscribe front_app front_app_switched

      sketchybar --add item clock right \
        --set clock \
          label.padding_right=10 \
          script="${clock}" \
        --subscribe clock system_clock

      ##### initial paint #####
      "${riftSpaces}" init
      "${frontApp}"
      "${clock}"
      sketchybar --update
    '';
  };

  # rift -> sketchybar: on rift startup, subscribe to its events and turn
  # them into sketchybar triggers. rift passes event context as env vars
  # (RIFT_WORKSPACE_NAME, RIFT_WINDOW_COUNT, ...) and fires the trigger; the
  # bar plugins re-query rift-cli for the actual state.
  services.rift.settings.run_on_start = lib.mkIf (options.services ? rift) [
    ''${lib.getExe' config.services.rift.package "rift-cli"} subscribe cli --event workspace_changed --command /bin/sh --args -c '${lib.getExe cfg.package} --trigger rift_workspace_changed RIFT_WORKSPACE_NAME="$RIFT_WORKSPACE_NAME" RIFT_WORKSPACE_ID="$RIFT_WORKSPACE_ID"' ''
    ''${lib.getExe' config.services.rift.package "rift-cli"} subscribe cli --event windows_changed --command /bin/sh --args -c '${lib.getExe cfg.package} --trigger rift_windows_changed RIFT_WORKSPACE_NAME="$RIFT_WORKSPACE_NAME" RIFT_WINDOW_COUNT="$RIFT_WINDOW_COUNT"' ''
  ];
}
