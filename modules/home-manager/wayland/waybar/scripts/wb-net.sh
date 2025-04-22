#!/usr/bin/env bash

while :; do
  alt="none"
  tooltip=""

  if=$(ip route | awk '$1=="default"{if (!found) {print $5; found=1}}')
  case $if in
    en*|eth*)
      alt="lan"
      tooltip=$if
      ;;
    wl*)
      alt="wifi"
      tooltip=$if
      ;;
    *)
      alt="none"
      ;;
  esac

  printf '{"alt": "%s", "tooltip": "%s"}\n' "$alt" "$tooltip"
  sleep 2
done
