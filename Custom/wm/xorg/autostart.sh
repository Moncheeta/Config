#!/usr/bin/env bash

xrdb $CONFIG_DIR/Custom/wm/xorg/X/resources
urxvtd --quiet --opendisplay --fork
himalaya notify &
feh --bg-scale $WALLPAPER
