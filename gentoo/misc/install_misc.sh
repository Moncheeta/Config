#!/usr/bin/env bash
# DO NOT RUN AS ROOT
CONFIG_DIR="/home/$USER/config"
cd $CONFIG_DIR/other/nerd-fonts && ./install.sh && cd
cargo install tokei himalaya
