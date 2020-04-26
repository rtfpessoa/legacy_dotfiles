#!/usr/bin/env bash

set -e

# Constants
SCRIPT_DIRECTORY="$( cd "$( dirname "$0" )" && pwd )"
BACKGROUNDS_DIRECTORY="${SCRIPT_DIRECTORY}/backgrounds"
BKG_IMG="${BACKGROUNDS_DIRECTORY}/$(ls ${BACKGROUNDS_DIRECTORY} | shuf -n 1)"

feh --no-fehbg --bg-fill ${BKG_IMG}
