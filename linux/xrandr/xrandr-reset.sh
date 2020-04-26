#!/usr/bin/env bash

INTERNAL_MONITOR="$(xrandr | grep "eDP" | grep -E " connected"  | awk '{print $1}')"
EXTERNAL_MONITORS=( $(xrandr | grep -v "${INTERNAL_MONITOR}" | grep -E " (dis)?connected"  | awk '{print $1}') )

# Reset
xrandr --output "${INTERNAL_MONITOR}" --primary --auto --pos 0x0 --rotate normal
for EXTERNAL_MONITOR in "${EXTERNAL_MONITORS[@]}"; do
    xrandr --output "${EXTERNAL_MONITOR}" --off
done
