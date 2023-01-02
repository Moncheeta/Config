#!/usr/bin/env bash

xrdb $CONFIG_DIR/Custom/wm/xorg/Xresources
urxvtd --quiet --opendisplay --fork
himalaya notify &
slstatus &
feh --bg-scale $WALLPAPER
