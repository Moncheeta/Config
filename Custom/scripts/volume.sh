#!/bin/bash

CURRENT="$(pamixer --get-volume)"
STEPS="5"

if [[ ${1} == "increase" ]]; then
    pamixer --increase $STEPS
elif [[ ${1} == "decrease" ]]; then
    pamixer --decrease $STEPS
elif [[ ${1} == "mute" ]]; then
    pamixer --toggle-mute
fi
