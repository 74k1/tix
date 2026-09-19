#!/usr/bin/env bash
# wg0 state: admin UP flag (addresses can linger after `networkctl down`,
# so the link flag is the source of truth)
is_up() {
    ip -o link show dev wg0 2>/dev/null | grep -qE '[,<]UP[>,]'
}

while :; do
    if is_up; then
        alt="up"
        tooltip="wg0: connected to eiri"
    else
        alt="down"
        tooltip="wg0: disconnected"
    fi

    printf '{"alt":"%s","class":"%s","tooltip":"%s"}\n' "$alt" "$alt" "$tooltip"
    sleep 2
done