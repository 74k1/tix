#!/usr/bin/env bash
set -euo pipefail

SINK_FILE="$(mktemp)"
PICKER="$(mktemp)"
trap 'rm -f "$SINK_FILE" "$PICKER"' EXIT

# Get sinks: description|sink_id
pactl list sinks | awk -v RS='\n\n' -v FS='\n' '
    {
        id=""; name=""; desc=""
        for (i=1;i<=NF;i++) {
            if ($i ~ /^Sink #/)          { id=$i; sub(/^Sink #/, "", id) }
            if ($i ~ /^\tName: /)        { name=$i; sub(/.*: /,"",name)  }
            if ($i ~ /^\tDescription: /) { desc=$i; sub(/.*: /,"",desc) }
        }
        if (name ~ /easyeffects/ || desc ~ /easyeffects/) next
        if (id != "" && name != "" && desc != "") printf "%s|%s\n", desc, id
    }' > "$SINK_FILE"

[[ -s "$SINK_FILE" ]] || { echo "No sinks found"; exit 1; }

# Picker script runs inside ghostty (has TTY for aurora)
cat > "$PICKER" << 'INNER'
#!/usr/bin/env bash
set -euo pipefail
SINK_FILE="$1"

CHOICE="$(cut -d'|' -f1 "$SINK_FILE" | aurora --dmenu)" || exit 0
[ -z "$CHOICE" ] && exit 0

SINK_ID="$(grep -F "$CHOICE" "$SINK_FILE" | cut -d'|' -f2 | head -1)"
[ -z "$SINK_ID" ] && { echo "Sink not found: $CHOICE"; sleep 3; exit 1; }

pactl set-default-sink "$SINK_ID"
for stream in $(pactl list short sink-inputs | cut -f1); do
    pactl move-sink-input "$stream" "$SINK_ID" 2>/dev/null || true
done

echo "Switched to: $CHOICE (sink #$SINK_ID)"
sleep 1
INNER
chmod +x "$PICKER"

exec ghostty +new-window --title=aurora-run -e "$PICKER" "$SINK_FILE"
