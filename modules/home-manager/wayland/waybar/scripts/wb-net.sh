#!/usr/bin/env bash
while :; do
    alt="none"
    tooltip=""

    IFS=: read -r ifname iftype _ _ \
        < <(nmcli -t dev status | awk -F: '$3=="connected"{print; exit}')

    case "$iftype" in
        ethernet)
            alt="lan"
            tooltip="$ifname"
            ;;
        wifi)
            s=$(nmcli -t -f SIGNAL --mode tabular dev wifi list --rescan no ifname "$ifname" 2>/dev/null | head -n1)
            s=${s:-0}
            if   (( s >= 90 )); then alt="wifi-4"
            elif (( s >= 51 )); then alt="wifi-3"
            elif (( s >= 11 )); then alt="wifi-2"
            else alt="wifi-1"
            fi
            tooltip="$ifname ${s}%"
            ;;
    esac

    printf '{"alt":"%s","tooltip":"%s"}\n' "$alt" "$tooltip"
    sleep 2
done
