#!/usr/bin/env bash

if [ -z "$1" ]; then
    usage
fi

ACTION="$1"

BRIGHTNESS_DRIVER="/sys/class/backlight/intel_backlight"
ACTUAL_BRIGHTNESS_FILE="${BRIGHTNESS_DRIVER}/actual_brightness"
MAX_BRIGHTNESS_FILE="${BRIGHTNESS_DRIVER}/max_brightness"
SET_BRIGHTNESS_FILE="${BRIGHTNESS_DRIVER}/brightness"

MIN_BRIGHTNESS="0"
MAX_BRIGHTNESS="$(cat ${MAX_BRIGHTNESS_FILE})"
CURRENT_BRIGHTNESS="$(cat ${ACTUAL_BRIGHTNESS_FILE})"

STEP="$(( $MAX_BRIGHTNESS / 40 ))"

function usage {
    echo "usage: $0 inc|dec|cur"
    exit 1
}

function set {
    echo "${1}" | tee "${SET_BRIGHTNESS_FILE}"
}

function dec {
    POSSIBLE_NEXT_BRIGHTNESS="$(( ${CURRENT_BRIGHTNESS} - ${STEP} ))"
    NEXT_BRIGHTNESS="$(( ${POSSIBLE_NEXT_BRIGHTNESS} < ${MIN_BRIGHTNESS} ? ${MIN_BRIGHTNESS} : ${POSSIBLE_NEXT_BRIGHTNESS} ))"
    set "${NEXT_BRIGHTNESS}"
}

function inc {
    POSSIBLE_NEXT_BRIGHTNESS="$(( ${CURRENT_BRIGHTNESS} + ${STEP} ))"
    NEXT_BRIGHTNESS="$(( ${POSSIBLE_NEXT_BRIGHTNESS} > ${MAX_BRIGHTNESS} ? ${MAX_BRIGHTNESS} : ${POSSIBLE_NEXT_BRIGHTNESS} ))"
    set "${NEXT_BRIGHTNESS}"
}

if [[ "${ACTION}" =~ "cur" ]]; then
    echo "$((100 * ${CURRENT_BRIGHTNESS} / ${MAX_BRIGHTNESS}))"
elif [[ "${ACTION}" =~ "dec" ]]; then
    dec
elif [[ "${ACTION}" =~ "inc" ]]; then
    inc
else
    echo "Could not find action '${ACTION}'"
    usage
fi
