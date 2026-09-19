#!/usr/bin/env bash
set -euo pipefail

# wg0 state: admin UP flag (addresses can linger after `networkctl down`,
# so the link flag is the source of truth)
is_up() {
    ip -o link show dev wg0 2>/dev/null | grep -qE '[,<]UP[>,]'
}

has_addr() {
    ip -4 -o addr show dev wg0 2>/dev/null | grep -q inet
}

if is_up; then
    if sudo -n /etc/wireguard/wg-toggle down; then
        notify-send -a WireGuard -i network-vpn-disabled "wg0 down"
    else
        notify-send -a WireGuard -u critical "wg0 down failed" "sudo rejected the command"
    fi
    exit 0
fi

if ! sudo -n /etc/wireguard/wg-toggle up; then
    notify-send -a WireGuard -u critical "wg0 up failed" "sudo rejected the command"
    exit 1
fi

# networkd applies the .network config once the link is administratively up;
# poll for link UP + address instead of trusting networkctl's exit code
for _ in $(seq 1 20); do
    if is_up && has_addr; then
        notify-send -a WireGuard -i network-vpn "wg0 up" "connected to eiri (10.100.0.6)"
        exit 0
    fi
    sleep 0.5
done

notify-send -a WireGuard -u critical "wg0 up failed" "interface did not come up within 10s"
exit 1