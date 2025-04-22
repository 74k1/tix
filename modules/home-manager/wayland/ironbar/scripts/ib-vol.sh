#!/usr/bin/env sh

BLUE='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

get_volume() {
  wpctl get-volume @DEFAULT_AUDIO_SINK@ | \
  awk '{
    vol = int($2 * 100 + 0.5);  # Rounded percentage
    if ($3 == "[MUTED]") vol = 0;
    printf "%d", vol
  }'
}

get_volume_icon() {
  vol=$1
  [ "$vol" -eq 0 ] && printf "󰝟" && return
  [ "$vol" -lt 33 ] && printf "󰕿" && return
  [ "$vol" -lt 66 ] && printf "󰖀" && return
  printf "󰕾"
}

generate_bar() {
  vol=$1
  segments=$(( (vol * 8 + 50) / 100 ))
  
  # Color logic
  # if [ "$vol" -eq 100 ]; then
  #   color="$RED"
  # elif [ "$vol" -gt 0 ]; then
  #   color="$BLUE"
  # else
  #   color=""
  # fi
  
  # Build bar
  bar="["
  i=0
  while [ "$i" -lt 8 ]; do
    if [ "$i" -lt "$segments" ]; then
      # bar="${bar}${color}|${NC}"
      bar="${bar}|"
    else
      bar="${bar} "
    fi
    i=$((i + 1))
  done
  bar="${bar}]"
  
  printf "%b" "$bar"
}

main() {
  vol=$(get_volume)
  icon=$(get_volume_icon "$vol")
  bar=$(generate_bar "$vol")
  
  /usr/bin/env echo -e "${icon} ${vol}% ${bar}"
}

main
