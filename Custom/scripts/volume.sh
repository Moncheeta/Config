#!/usr/bin/env bash

CURRENT="$(pamixer --get-volume)"
STEPS="5"

if [[ ${1} == "increase" ]]; then
    pamixer --increase $STEPS
elif [[ ${1} == "decrease" ]]; then
    pamixer --decrease $STEPS
elif [[ ${1} == "mute" ]]; then
    pamixer --toggle-mute
elif [[ ${1} == "listen" ]]; then
    firstrun=0
    pactl subscribe 2>/dev/null | {
        while true; do {
            if [ $firstrun -eq 0 ]; then
                firstrun=1
            else
                read -r event || break
                if ! echo "$event" | grep -e "on card" -e "on sink"
                then
                    continue
                fi
            fi
        } &>/dev/null
        pamixer --get-volume-human
    done
    }
fi
