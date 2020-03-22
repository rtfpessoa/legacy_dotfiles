#!/usr/bin/env bash

#
# Setup disposition
#
# 1k - 1k
#   4k
#

SCRIPT_DIRECTORY="$( cd "$( dirname "$0" )" && pwd )"

${SCRIPT_DIRECTORY}/xrandr-reset.sh

xrandr \
    --output DP-3 --mode 1920x1080 --pos 0x0 --rotate normal \
    --output DP-1 --mode 1920x1080 --pos 2880x0 --rotate normal \
    --output eDP-1 --primary --mode 3840x2160 --pos 816x1620 --rotate normal
