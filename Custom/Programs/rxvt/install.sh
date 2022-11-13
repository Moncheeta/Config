#!/bin/sh

sudo cp $CONFIG_DIR/Custom/Programs/.Xresources ~
sudo mkdir ~/.urxvt
sudo mkdir ~/.urxvt/ext
sudo cp -r $CONFIG_DIR/Custom/Programs/rxvt/urxvt-perls/keyboard-select $CONFIG_DIR/Custom/Programs/rxvt/urxvt-perls/deprecated/clipboard $CONFIG_DIR/Custom/Programs/rxvt/urxvt-perls/deprecated/url-select ~/.urxvt/ext
