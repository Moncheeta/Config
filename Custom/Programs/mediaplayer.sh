#!/bin/sh

waybar() {
    echo $(sed -e 's/&/and/g' <<< "$1") # waybar doesn't like ambersands
}

while true; do
    player_status=$(playerctl -a status 2> /dev/null | tail -n1)
    if [ "$player_status" = "Playing" ]; then
        player_artist=$(playerctl metadata artist)
        player_song=$(playerctl metadata title)
        echo $(waybar "$player_artist - $player_song")
    elif [ "$player_status" = "Paused" ]; then
        echo " "
    fi
done
