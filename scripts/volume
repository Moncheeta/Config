#!/usr/bin/env bash

STEPS="5"
PVOL=$(awk -F"[][]" '/Mono:/ { print $2 }' <(amixer sget Master)) # to get the current volume + percent sign
VOL=${PVOL%\%} # volume without the percent sign

if [[ ${1} == "increase" ]]; then
    amixer set Master unmute # make sure that the audio is on
    NEW_VOL=$((${VOL}+${STEPS}))
    if [[ $NEW_VOL -ge 100 ]]; then
        amixer sset Master 100%
        exit
    fi
    amixer sset Master $NEW_VOL%
elif [[ ${1} == "decrease" ]]; then
    amixer set Master unmute # make sure that the audio is on
    NEW_VOL=$(($VOL-$STEPS))
    if [[ $NEW_VOL -le 0 ]]; then
        amixer sset Master 0%
        exit
    fi
    amixer sset Master $NEW_VOL%
elif [[ ${1} == "mute" ]]; then
    amixer sset Master mute
elif [[ ${1} == "unmute" ]]; then
    amixer sset Master unmute
elif [[ ${1} == "toggle" ]]; then
    amixer sset Master toggle
elif [[ ${1} == "get" ]]; then
    STATE=$(amixer sget Master | egrep -o '\[o.+\]')
    if [[ ${STATE} == "[off]" ]]; then
        echo "muted"
        exit
    fi
    if [[ ${2} == "human" ]]; then
        echo $VOL%
    else
        echo $VOL
    fi
elif [[ ${1} == "set" ]]; then # example input = 2 <- No percent sign
    amixer set Master unmute # make sure that the audio is on
    if [[ ${2} -ge 100 ]]; then
        amixer sset Master 100%
        exit
    elif [[ ${2} -le 0 ]]; then
        amixer sset Master 0%
        exit
    fi
    amixer sset Master $2%
fi
