#!/usr/bin/env bash
set -euo pipefail

# aurora is a TUI and needs a terminal. Waybar launches scripts without a TTY,
# so bounce into Ghostty first, re-running this script there.
if [[ "${1:-}" != "--pick" && ( ! -t 0 || ! -t 1 ) ]]; then
    exec ghostty +new-window --title=aurora-run -e "$0" --pick
fi

if [[ "${1:-}" == "--pick" ]]; then
    shift
fi

mapfile -t ENTRIES < <(
    pactl list sinks |
    awk -v RS='\n\n' -v FS='\n' '
        {
            id=""; name=""; desc=""
            for (i=1;i<=NF;i++) {
                if ($i ~ /^Sink #/)          { id=$i; sub(/^Sink #/, "", id) }
                if ($i ~ /^\tName: /)        { name=$i; sub(/.*: /,"",name)  }
                if ($i ~ /^\tDescription: /) { desc=$i; sub(/.*: /,"",desc) }
            }
            if (name ~ /easyeffects/ || desc ~ /easyeffects/) next
            if (id != "" && name != "" && desc != "") {
                printf "%s (#%s)|%s\n", desc, id, name
            }
        }'
)

[[ ${#ENTRIES[@]} -eq 0 ]] && { echo "No suitable sinks found."; exit 1; }

if ! CHOICE="$(printf '%s\n' "${ENTRIES[@]}" | cut -d'|' -f1 | aurora --dmenu)"; then
    exit 0
fi

[[ -z "$CHOICE" ]] && exit 0

SINK_NAME="$(printf '%s\n' "${ENTRIES[@]}" | awk -F '|' -v c="$CHOICE" '
    $1==c { print $2; exit }')"

[[ -z "$SINK_NAME" ]] && exit 1

pactl set-default-sink "$SINK_NAME"
