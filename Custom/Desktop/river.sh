#!/bin/sh

# Applications
riverctl map normal Super T spawn alacritty

# Windows
riverctl map normal Super+Shift C close
riverctl map normal Super+Shift Return zoom
riverctl map normal Super+Shift V toggle-float
riverctl map normal Super+Shift F toggle-fullscreen

## Focus
riverctl map normal Super J focus-view next
riverctl map normal Super K focus-view previous

## Swap
riverctl map normal Super+Shift J swap next
riverctl map normal Super+Shift K swap previous

## Snap
riverctl map normal Super+Alt+Control H snap left
riverctl map normal Super+Alt+Control J snap down
riverctl map normal Super+Alt+Control K snap up
riverctl map normal Super+Alt+Control L snap right

## Ratio
riverctl map normal Super H send-layout-cmd rivertile "main-ratio -0.05"
riverctl map normal Super L send-layout-cmd rivertile "main-ratio +0.05"

## Displays
### Focus
riverctl map normal Super Period focus-output next
riverctl map normal Super Comma focus-output previous

### Swap
riverctl map normal Super+Shift Period send-to-output next
riverctl map normal Super+Shift Comma send-to-output previous

## Views
### Move
riverctl map normal Super+Alt H move left 100
riverctl map normal Super+Alt J move down 100
riverctl map normal Super+Alt K move up 100
riverctl map normal Super+Alt L move right 100
riverctl map-pointer normal Super BTN_LEFT move-view

### Snap
riverctl map normal Super+Alt+Control H snap left
riverctl map normal Super+Alt+Control J snap down
riverctl map normal Super+Alt+Control K snap up
riverctl map normal Super+Alt+Control L snap right

### Ratio
riverctl map normal Super+Alt+Shift H resize horizontal -100
riverctl map normal Super+Alt+Shift J resize vertical 100
riverctl map normal Super+Alt+Shift K resize vertical -100
riverctl map normal Super+Alt+Shift L resize horizontal 100
riverctl map-pointer normal Super BTN_RIGHT resize-view

# Other
riverctl map normal Super+Shift E exit

riverctl map normal Super+Shift H send-layout-cmd rivertile "main-count +1"
riverctl map normal Super+Shift L send-layout-cmd rivertile "main-count -1"

# Tags
for i in $(seq 1 9)
do
    tags=$((1 << ($i - 1)))
    riverctl map normal Super $i set-focused-tags $tags
    riverctl map normal Super+Shift $i set-view-tags $tags
    riverctl map normal Super+Control $i toggle-focused-tags $tags
    riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
done

all_tags=$(((1 << 32) - 1))
riverctl map normal Super 0 set-focused-tags $all_tags
riverctl map normal Super+Shift 0 set-view-tags $all_tags

riverctl map normal Super Up    send-layout-cmd rivertile "main-location top"
riverctl map normal Super Right send-layout-cmd rivertile "main-location right"
riverctl map normal Super Down  send-layout-cmd rivertile "main-location bottom"
riverctl map normal Super Left  send-layout-cmd rivertile "main-location left"

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

riverctl default-layout rivertile

swaybg -i $WALLPAPER &
waybar &
