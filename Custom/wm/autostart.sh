#!/usr/bin/env bash

xrdb $CONFIG_DIR/Custom/wm/xorg/Xresources
urxvtd --quiet --opendisplay --fork
slstatus &
# dunst &
feh --bg-scale $WALLPAPER
