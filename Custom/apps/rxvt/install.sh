#!/bin/sh

doas cp ../.Xresources ~
doas mkdir ~/.urxvt
doas mkdir ~/.urxvt/ext
doas cp -r ./urxvt-perls/keyboard-select ./urxvt-perls/deprecated/clipboard ./urxvt-perls/deprecated/url-select ~/.urxvt/ext
