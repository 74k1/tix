#!/usr/bin/env sh

if [ -n "$1" ]; then
    vol=$(($1 > 100 ? 100 : ($1 < 0 ? 0 : $1)))
    wpctl set-volume @DEFAULT_AUDIO_SINK@ "$(awk -v vol="$vol" 'BEGIN {printf "%.2f", vol/100}')"
    exit
fi

get_volume() {
  wpctl get-volume @DEFAULT_AUDIO_SINK@ | \
  awk '{
    vol = int($2 * 100 + 0.5);
    if ($3 == "[MUTED]") vol = 0;
    printf "%d", vol
  }'
}

vol=$(get_volume)
echo "$vol"
