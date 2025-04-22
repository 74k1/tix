#!/usr/bin/env sh

get_mem_info() {
  while read -r key val _; do
    case "$key" in
      MemTotal:) total=$val ;;
      MemAvailable:) available=$val ;;
    esac
  done < /proc/meminfo
  printf "%s %s" "$total" "$available"
}

generate_bar() {
  percent=$1
  segments=$(( (percent * 8) / 100 ))  # 8 segments
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
  read -r total available <<EOF
$(get_mem_info)
EOF
  used=$((total - available))
  percent=$(( (used * 100) / total ))
  bar=$(generate_bar "$percent")
  # printf "  %d%% %s\n" "$percent" "$bar"
  printf "MEM %d%% %s\n" "$percent" "$bar"
}

main
