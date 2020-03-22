#!/usr/bin/env bash

#
# Setup disposition
#
# 4k
# 4k
#

SCRIPT_DIRECTORY="$( cd "$( dirname "$0" )" && pwd )"

${SCRIPT_DIRECTORY}/xrandr-reset.sh

xrandr \
    --output eDP-1 --mode 3840x2160 --pos 0x2160 --rotate normal \
    --output DP-1 --primary --mode 3840x2160 --pos 0x0 --rotate normal
