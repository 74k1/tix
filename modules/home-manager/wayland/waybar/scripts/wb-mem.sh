#!/usr/bin/env bash

# memory_usage_json.sh – print a JSON line with the memory-% used every second
# Example output: {"percentage": 42.7}

while :; do
    # Read the fields we need from /proc/meminfo (values are in kB)
    read total_kb <<< "$(awk '/^MemTotal:/  {print $2}'  /proc/meminfo)"
    read avail_kb <<< "$(awk '/^MemAvailable:/{print $2}' /proc/meminfo)"

    # If MemAvailable is zero / missing (old systems), calculate “free” manually.
    if [[ -z "$avail_kb" || "$avail_kb" -eq 0 ]]; then
        read free_kb  <<< "$(awk '/^MemFree:/   {print $2}'  /proc/meminfo)"
        read cached_kb <<< "$(awk '/^Cached:/    {print $2}'  /proc/meminfo)"
        read buffers_kb <<< "$(awk '/^Buffers:/   {print $2}' /proc/meminfo)"
        avail_kb=$(( free_kb + cached_kb + buffers_kb ))
    fi

    # Percentage used = (total - available) / total * 100
    used_kb=$(( total_kb - avail_kb ))
    percentage=$(awk -v u="$used_kb" -v t="$total_kb" 'BEGIN { printf "%.1f", (u/t)*100 }')

    printf '{"percentage": %s}\n' "$percentage"
    sleep 1
done
