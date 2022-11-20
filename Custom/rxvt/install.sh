#!/bin/sh

sudo cp ../.Xresources ~
sudo mkdir ~/.urxvt
sudo mkdir ~/.urxvt/ext
sudo cp -r ./urxvt-perls/keyboard-select ./urxvt-perls/deprecated/clipboard ./urxvt-perls/deprecated/url-select ~/.urxvt/ext
