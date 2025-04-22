#!/usr/bin/env sh

get_cpu_metrics() {
  while read -r cpu user nice system idle iowait irq softirq steal _ _; do
    [ "$cpu" = "cpu" ] && break
  done < /proc/stat
  total=$((user + nice + system + idle + iowait + irq + softirq + steal))
  nonidle=$((user + nice + system + irq + softirq + steal))
  printf "%s %s" "$total" "$nonidle"
}

main() {
  # Take first measurement
  read -r total1 nonidle1 <<EOF
$(get_cpu_metrics)
EOF
  sleep 1
  # Take second measurement
  read -r total2 nonidle2 <<EOF
$(get_cpu_metrics)
EOF

  # Calculate CPU usage (integer math only)
  total_delta=$((total2 - total1))
  [ "$total_delta" -eq 0 ] && percent=0 || \
    percent=$(( ( (nonidle2 - nonidle1) * 100 ) / total_delta ))

  # Build the 8-segment bar
  segments=$(( percent / 13 ))  # 100% / 8 ≈ 12.5% per segment
  [ "$segments" -gt 8 ] && segments=8  # Cap at 8 segments
  bar="["
  i=0
  while [ "$i" -lt 8 ]; do
    [ "$i" -lt "$segments" ] && bar="${bar}|" || bar="${bar} "
    i=$((i + 1))
  done
  bar="${bar}]"

  # Output
  # printf " %d%% %s\n" "$percent" "$bar"
  printf "CPU %d%% %s\n" "$percent" "$bar"
}

main
