#!/usr/bin/env bash

hc() {
    herbstclient "$@"
}

hc emit_hook reload

# autostart
source $CONFIG_DIR/Custom/wm/xorg/autostart.sh

## polybar
killall -q polybar
polybar --config=$CONFIG_DIR/Custom/wm/xorg/polybar.conf mainbar-herb &

# remove all existing keybindings
hc keyunbind --all

# keybindings
Mod=Mod4   # Use the super key as the main modifier

hc keybind $Mod-Shift-q quit
hc keybind $Mod-Shift-r reload
hc keybind $Mod-Shift-c close
hc keybind $Mod-t spawn $TERMINAL
hc keybind $Mod-w spawn $BROWSER

# basic movement in tiling and floating mode
# focusing clients
hc keybind $Mod-Left  focus left
hc keybind $Mod-Down  focus down
hc keybind $Mod-Up    focus up
hc keybind $Mod-Right focus right

# moving clients in tiling and floating mode
hc keybind $Mod-Shift-Left  shift left
hc keybind $Mod-Shift-Down  shift down
hc keybind $Mod-Shift-Up    shift up
hc keybind $Mod-Shift-Right shift right

# splitting frames
# create an empty frame at the specified direction
hc keybind $Mod-u       split   bottom  0.5
hc keybind $Mod-o       split   right   0.5
hc set default_frame_layout horizontal

# let the current frame explode into subframes
hc keybind $Mod-Control-space split explode

# resizing frames and floating clients
resizestep=0.02
hc keybind $Mod-Control-Left    resize left  +$resizestep
hc keybind $Mod-Control-Down    resize down  +$resizestep
hc keybind $Mod-Control-Up      resize up    +$resizestep
hc keybind $Mod-Control-Right   resize right +$resizestep

# tags
tag_names=( {1..9} )
tag_keys=(  {1..9} 0 )

hc rename default "${tag_names[0]}" || true
for i in "${!tag_names[@]}" ; do
    hc add "${tag_names[$i]}"
    key="${tag_keys[$i]}"
    if [ -n "$key" ] ; then
        hc keybind "$Mod-$key" use_index "$i"
        hc keybind "$Mod-Shift-$key" move_index "$i"
    fi
done

# cycle through tags
hc keybind $Mod-period use_index +1 --skip-visible
hc keybind $Mod-comma  use_index -1 --skip-visible

# layouting
hc keybind $Mod-r remove
hc keybind $Mod-s floating toggle
hc keybind $Mod-f fullscreen toggle
hc keybind $Mod-Shift-f set_attr clients.focus.floating  toggle
hc keybind $Mod-Shift-d set_attr clients.focus.decorated toggle
hc keybind $Mod-Shift-m set_attr clients.focus.minimized true
hc keybind $Mod-Control-m jumpto last-minimized
# The following cycles through the available layouts within a frame, but skips
# layouts, if the layout change wouldn't affect the actual window positions.
# I.e. if there are two windows within a frame, the grid layout is skipped.
hc keybind $Mod-space                                                           \
            or , and . compare tags.focus.curframe_wcount = 2                   \
                     . cycle_layout +1 vertical horizontal max vertical grid    \
               , cycle_layout +1

# focus
hc keybind $Mod-BackSpace   cycle_monitor
hc keybind $Mod-Tab         cycle_all +1
hc keybind $Mod-Shift-Tab   cycle_all -1

# volume
hc keybind XF86AudioRaiseVolume spawn $CONFIG_DIR/Custom/scripts/volume.sh increase
hc keybind XF86AudioLowerVolume spawn $CONFIG_DIR/Custom/scripts/volume.sh decrease

# brightness
hc keybind XF86MonBrightnessUp spawn $CONFIG_DIR/Custom/scripts/brightness.sh increase
hc keybind XF86MonBrightnessDown spawn $CONFIG_DIR/Custom/scripts/brightness.sh decrease

# theme
hc attr theme.tiling.reset 1
hc attr theme.floating.reset 1

background='#111313'
foreground='#986b9e'

hc attr theme.active.color $foreground
hc attr theme.normal.color $background
hc attr theme.background_color $background

hc set frame_bg_active_color $foreground
hc set frame_bg_transparent on
hc set frame_transparent_width 5

## decorations
hc set show_frame_decorations 'focused_if_multiple'
hc attr theme.title_when never
hc set frame_border_width 0
hc attr theme.border_width 3

## floating
hc attr theme.floating.border_width 5
hc attr theme.floating.outer_width 0

# gaps
hc set frame_gap 0
hc set window_gap 0
hc set frame_padding 0
hc set smart_window_surroundings off
hc set smart_frame_surroundings off
hc set mouse_recenter_gap 0

# rules
hc unrule -F
hc rule class=Firefox tag=2
hc rule focus=on
hc rule floatplacement=smart
hc rule windowtype~'_NET_WM_WINDOW_TYPE_(DIALOG|UTILITY|SPLASH)' floating=on
hc rule windowtype='_NET_WM_WINDOW_TYPE_DIALOG' focus=on
hc rule windowtype~'_NET_WM_WINDOW_TYPE_(NOTIFICATION|DOCK|DESKTOP)' manage=off
hc rule fixedsize floating=on

hc set tree_style '╾│ ├└╼─┐'

# unlock, just to be sure
hc unlock

hc detect_monitors
