#!/usr/bin/env sh

get_volume() {
  wpctl get-volume @DEFAULT_AUDIO_SINK@ | \
    awk '{
        vol = $2 * 100; 
        if ($3 == "[MUTED]") vol = 0;
        printf "%d", vol
    }'
}

generate_bar() {
    percent=$1
    segments=$(( (percent * 8) / 100 ))
    [ "$segments" -gt 8 ] && segments=8
    bar="["
    i=0
    while [ "$i" -lt 8 ]; do
        [ "$i" -lt "$segments" ] && bar="${bar}|" || bar="${bar} "
        i=$((i + 1))
    done
    printf "%s]" "$bar"
}

main() {
    vol=$(get_volume)
    bar=$(generate_bar "$vol")
    # printf "🔊 %d%% %s\n" "$vol" "$bar"
    printf "%s\n" "$bar"
}

main
