#!/usr/bin/env bash

SCRIPT_DIRECTORY="$( cd "$( dirname "$0" )" && pwd )"

NR_CONNECTED_MONITORS="$(xrandr | grep -E " connected"  | awk '{print $1}' | wc -l)"
INTERNAL_MONITOR="$(xrandr | grep "eDP" | grep -E " connected"  | awk '{print $1}')"
EXTERNAL_MONITORS=( $(xrandr | grep -v "${INTERNAL_MONITOR}" | grep -E " connected"  | awk '{print $1}') )

# ALL_MONITORS=( $(xrandr | grep -E " (connected|disconnected)"  | awk '{print $1}') )
# NR_MONITORS="$(xrandr | grep -E " (dis)?connected"  | awk '{print $1}' | wc -l)"
# CONNECTED_MONITORS=( $(xrandr | grep -E " connected"  | awk '{print $1}') )
# DISCONNECTED_MONITORS=( $(xrandr | grep -E " disconnected"  | awk '{print $1}') )

${SCRIPT_DIRECTORY}/xrandr-reset.sh

# Setup enabled monitors
if [ ${NR_CONNECTED_MONITORS} -eq 2 ]; then
    SECONDARY_MONITOR="${EXTERNAL_MONITORS[0]}"
    SECONDARY_MONITOR_POSITION="above"
    xrandr \
        --output "${SECONDARY_MONITOR}" --primary --auto --${SECONDARY_MONITOR_POSITION} "${INTERNAL_MONITOR}" --rotate normal \
        --output "${INTERNAL_MONITOR}" --auto --rotate normal
elif [ ${NR_CONNECTED_MONITORS} -eq 3 ]; then
    # TODO: How to generalize this?
    xrandr \
        --output DP-3 --mode 1920x1080 --pos 3840x1080 --rotate normal --scale 1.8x1.8 \
        --output "${INTERNAL_MONITOR}" --mode 3840x2160 --pos 0x2160 --rotate normal \
        --output DP-1 --primary --mode 3840x2160 --pos 0x0 --rotate normal
fi

feh --bg-fill /usr/share/backgrounds/Manhattan_Sunset_by_Giacomo_Ferroni.jpg
