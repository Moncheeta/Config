#!/bin/sh

# Services
## Power
sudo ln -s /etc/sv/tlp /var/service

## Network
sudo rm /var/service/wpa_supplicant /var/service/dhcpcd
sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/NetworkManager /var/service

# Configuration
cp $CONFIG_DIR/Custom/starship.toml ~/.config/
mkdir ~/.config/fish
cp $CONFIG_DIR/Custom/shell.fish ~/.config/fish/config.fish
mkdir ~/.config/nvim
cp $CONFIG_DIR/Custom/neovim.lua ~/.config/nvim/init.lua
mkdir ~/.config/peaclock
cp $CONFIG_DIR/Custom/peaclock.conf ~/.config/peaclock/config
mkdir ~/.config/herbstluftwm
cp $CONFIG_DIR/Custom/herbstluftwm.sh ~/.config/herbstluftwm/autostart
mkdir ~/.config/htop
cp $CONFIG_DIR/Custom/htoprc ~/.config/htop
cp $CONFIG_DIR/Custom/xinitrc ~/.xinitrc

# Other
sudo xbps-reconfigure -fav
