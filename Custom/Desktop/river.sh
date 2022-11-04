#!/bin/sh

# Applications
riverctl map normal Super T spawn alacritty
riverctl map normal Super W spawn firefox

# Windows
riverctl map normal Super+Shift C close
riverctl map normal Super+Shift Return zoom
riverctl map normal Super+Shift V toggle-float
riverctl map normal Super+Shift F toggle-fullscreen

## Focus
riverctl map normal Super Up focus-view next
riverctl map normal Super Down focus-view previous

## Move
riverctl map-pointer normal Super BTN_LEFT move-view
riverctl map normal Super+Alt Left move left 100
riverctl map normal Super+Alt Down move down 100
riverctl map normal Super+Alt Up move up 100
riverctl map normal Super+Alt Right move right 100

## Size
riverctl map-pointer normal Super BTN_RIGHT resize-view
riverctl map normal Super Left send-layout-cmd rivertile "main-ratio -0.05"
riverctl map normal Super Right send-layout-cmd rivertile "main-ratio +0.05"
riverctl map normal Super+Control Left resize horizontal -100
riverctl map normal Super+Control Down resize vertical 100
riverctl map normal Super+Control Up resize vertical -100
riverctl map normal Super+Control Right resize horizontal 100

## Displays
### Focus
riverctl map normal Super Period focus-output next
riverctl map normal Super Comma focus-output previous

### Swap
riverctl map normal Super+Shift Period send-to-output next
riverctl map normal Super+Shift Comma send-to-output previous

# Other
riverctl map normal Super+Shift E exit

# Tags
for i in $(seq 1 9)
do
    tags=$((1 << ($i - 1)))
    riverctl map normal Super $i set-focused-tags $tags
    riverctl map normal Super+Alt $i set-view-tags $tags
    riverctl map normal Super+Control $i toggle-focused-tags $tags
    riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
done

all_tags=$(((1 << 32) - 1))
riverctl map normal Super 0 set-focused-tags $all_tags
riverctl map normal Super+Shift 0 set-view-tags $all_tags

for mode in normal locked
do
    riverctl map $mode None XF86AudioRaiseVolume  spawn 'pamixer -i 5'
    riverctl map $mode None XF86AudioLowerVolume  spawn 'pamixer -d 5'
    riverctl map $mode None XF86AudioMute         spawn 'pamixer --toggle-mute'
    riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
    riverctl map $mode None XF86AudioPlay  spawn 'playerctl play-pause'
    riverctl map $mode None XF86AudioPrev  spawn 'playerctl previous'
    riverctl map $mode None XF86AudioNext  spawn 'playerctl next'
    riverctl map $mode None XF86MonBrightnessUp   spawn 'light -A 5'
    riverctl map $mode None XF86MonBrightnessDown spawn 'light -U 5'
done

# Keyboard repeat rate
riverctl set-repeat 50 300

# Colors
riverctl border-color-focused 0xb39df3
riverctl border-color-unfocused 0x27f8490

# Default Layout
riverctl spawn rivertile
riverctl output-layout rivertile

swaybg -i $WALLPAPER &
waybar &
