#!/usr/bin/env bash

set -e

# Source: https://github.com/jD91mZM2/xidlehook
#
# docker run -it --rm --net=host --entrypoint=bash -v $PWD:/pwd rust
# apt -y update
# apt -y install libpulse-dev libxcb-screensaver0-dev
# git clone https://gitlab.com/jD91mZM2/xidlehook
# cd xidlehook
# cargo build --release --bins
#

SCRIPT_DIRECTORY="$( cd "$( dirname "$0" )" && pwd )"
export LOCK_PATH="${SCRIPT_DIRECTORY}/lock.sh"

# Only exported variables can be used within the timer's command.
export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"

# xautolock -time 1 -notify 5 -notifier 'notify-send -u critical -t 10000 "Locking screen in 5 seconds"' -locker "$LOCK"
xidlehook \
  `# Don't lock when there's a fullscreen application` \
  --not-when-fullscreen \
  `# Don't lock when there's audio playing` \
  --not-when-audio \
  `# Dim the screen after 60 seconds, undim if user becomes active` \
  --timer 180 \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness .1' \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness 1' \
  `# Undim & lock after 10 more seconds` \
  --timer 10 \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness 1; $LOCK_PATH' \
    '' \
  `# Finally, suspend an hour after it locks` \
  --timer 1800 \
    'systemctl suspend-then-hibernate' \
    ''
