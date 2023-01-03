#!/usr/bin/env bash

xrdb $CONFIG_DIR/Custom/wm/xorg/Xresources
urxvtd --quiet --opendisplay --fork
himalaya notify &
slstatus &
dunst &
feh --bg-scale $WALLPAPER
