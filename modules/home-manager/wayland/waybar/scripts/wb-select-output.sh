#!/usr/bin/env bash
set -euo pipefail

mapfile -t ENTRIES < <(
    pactl list sinks |
    awk -v RS='\n\n' -v FS='\n' '
        $0 ~ /easyeffects/ { next }
        {
            for (i=1;i<=NF;i++) {
                if ($i ~ /^Sink #/)          { id=$i; sub(/^Sink #/, "", id) }
                if ($i ~ /^\tName: /)        { name=$i; sub(/.*: /,"",name)  }
                if ($i ~ /^\tDescription: /) { desc=$i; sub(/.*: /,"",desc) }
            }
            printf "%s|#%s|%s\n", desc, id, name     # friendly|index|raw_name
        }'
)

[[ ${#ENTRIES[@]} -eq 0 ]] && { echo "No suitable sinks found."; exit 1; }

CHOICE="$(printf '%s\n' "${ENTRIES[@]}" | cut -d'|' -f1 |
          fuzzel --dmenu -p 'Audio output: ' --width 50)"

[[ -z "$CHOICE" ]] && exit 0

SINK_NAME="$(printf '%s\n' "${ENTRIES[@]}" | awk -F '|' -v c="$CHOICE" '
    $1==c { print $3 }')"

pactl set-default-sink "$SINK_NAME"
