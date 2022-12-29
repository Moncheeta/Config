#!/bin/bash

cd /sys/class/backlight

TARGET="intel_backlight"
MAX="$(cat ${TARGET}"/max_brightness")"
CURRENT="$(cat ${TARGET}"/brightness")"
STEPS="50"

if [ -w "./"$TARGET"/brightness" ]; then
    if [[ ${1} == "increase" ]]; then
        (( CURRENT += $STEPS ))
    fi
    if [[ $1 == "decrease" ]]; then
        (( CURRENT -= ${STEPS} ))
    fi
    if [[ $CURRENT -gt ${MAX} ]];then
        exit;
    fi
    if [[ $CURRENT -lt 1 ]]; then
        CURRENT = 0
    fi
    echo "${CURRENT}" > "${TARGET}/brightness"
else
    doas -S chmod 777 "./"$TARGET"/brightness"
fi
