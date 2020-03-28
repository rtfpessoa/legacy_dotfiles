#!/usr/bin/env bash

# Source: https://raw.githubusercontent.com/ShikherVerma/i3lock-multimonitor/master/lock

set -e 

revert() {
    xset dpms 0 0 0
}

lock_screen() {
    xset +dpms dpms 5 5 5
    $LOCK_CMD
    revert
}

trap revert HUP INT TERM

# Constants
SCRIPT_DIRECTORY="$( cd "$( dirname "$0" )" && pwd )"
BACKGROUNDS_DIRECTORY="${SCRIPT_DIRECTORY}/backgrounds"
BKG_IMG="${BACKGROUNDS_DIRECTORY}/$(ls ${BACKGROUNDS_DIRECTORY} | shuf -n 1)"
LOCK_ARGS="--ignore-empty-password --show-failed-attempts --nofork"
DISPLAY_RE="([0-9]+)x([0-9]+)\\+([0-9]+)\\+([0-9]+)" # Regex to find display dimensions
CACHE_FOLDER="$HOME"/.cache/i3lock/backgrounds/ # Cache folder
if ! [ -e $CACHE_FOLDER ]; then
    mkdir -p $CACHE_FOLDER
fi

if ! [ -e "$BKG_IMG" ]; then
    echo "No background image! Exiting..."
    exit 2
fi

MD5_BKG_IMG=$(md5sum $BKG_IMG | cut -c 1-10)
MD5_SCREEN_CONFIG=$(xrandr | md5sum - | cut -c 1-32) # Hash of xrandr output
OUTPUT_IMG="$CACHE_FOLDER""$MD5_SCREEN_CONFIG"."$MD5_BKG_IMG".png # Path of final image
OUTPUT_IMG_WIDTH=0 # Decide size to cover all screens
OUTPUT_IMG_HEIGHT=0 # Decide size to cover all screens

# i3lock command
LOCK_BASE_CMD="i3lock -i $OUTPUT_IMG"
LOCK_CMD="$LOCK_BASE_CMD $LOCK_ARGS"

if [ -e $OUTPUT_IMG ]; then
    # Lock screen since image already exists
    lock_screen
    exit 0
fi

# Execute xrandr to get information about the monitors
while read LINE; do
  # If we are reading the line that contains the position information
  if [[ $LINE =~ $DISPLAY_RE ]]; then
    echo ""
    echo "LINE"
    echo ""
    echo $LINE
    echo ""
    # Extract information and append some parameters to the ones that will be given to ImageMagick
    SCREEN_WIDTH=${BASH_REMATCH[1]}
    SCREEN_HEIGHT=${BASH_REMATCH[2]}
    SCREEN_X=${BASH_REMATCH[3]}
    SCREEN_Y=${BASH_REMATCH[4]}
    
    CACHE_IMG="$CACHE_FOLDER""$SCREEN_WIDTH"x"$SCREEN_HEIGHT"."$MD5_BKG_IMG".png
    # If cache for that screensize doesnt exist
    if ! [ -e $CACHE_IMG ]; then
	    # Create image for that screensize
        eval convert '$BKG_IMG' '-resize' '${SCREEN_WIDTH}X${SCREEN_HEIGHT}^' '-gravity' 'Center' '-crop' '${SCREEN_WIDTH}X${SCREEN_HEIGHT}+0+0' '+repage' '$CACHE_IMG'
    fi

    # Decide size of output image
    if (( $OUTPUT_IMG_WIDTH < $SCREEN_WIDTH+$SCREEN_X )); then OUTPUT_IMG_WIDTH=$(($SCREEN_WIDTH+$SCREEN_X)); fi;
    if (( $OUTPUT_IMG_HEIGHT < $SCREEN_HEIGHT+$SCREEN_Y )); then OUTPUT_IMG_HEIGHT=$(( $SCREEN_HEIGHT+$SCREEN_Y )); fi;

    PARAMS="$PARAMS -type TrueColor $CACHE_IMG -geometry +$SCREEN_X+$SCREEN_Y -composite "
  fi
done <<<"$(xrandr | grep " connected ")"

# Execute ImageMagick
eval convert -size ${OUTPUT_IMG_WIDTH}x${OUTPUT_IMG_HEIGHT} 'xc:black' $OUTPUT_IMG
eval convert $OUTPUT_IMG $PARAMS $OUTPUT_IMG

# Lock the screen
lock_screen
