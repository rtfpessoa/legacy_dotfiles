#!/usr/bin/env bash

#
# Setup disposition
#
# 4k - 1k
# 4k
#

SCRIPT_DIRECTORY="$( cd "$( dirname "$0" )" && pwd )"

${SCRIPT_DIRECTORY}/xrandr-reset.sh

xrandr \
    --output DP-3 --mode 1920x1080 --pos 3840x1080 --rotate normal --scale 1.8x1.8 \
    --output eDP-1 --mode 3840x2160 --pos 0x2160 --rotate normal \
    --output DP-1 --primary --mode 3840x2160 --pos 0x0 --rotate normal
