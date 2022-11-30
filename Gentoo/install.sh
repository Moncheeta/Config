CONFIG="$HOME/Config"

emerge -ask --verbose --changed-use --update --deep @world

# Packages
emerge --ask media-video/pipewire media-video/wireplumber

# Configurations
mkdir $HOME/.config/fish
cp $CONFIG/Gentoo/gentoo.fish ~/.config/fish/conf.d/
cp $CONFIG/Custom/wm/.xinitrc ~
cp $CONFIG/Custom/apps/.Xresources ~
mkdir $HOME/.config/htop
cp $CONFIG/Custom/terminal/htoprc ~/.config/htop/
cp /usr/share/pipewire/pipewire.conf /etc/pipewire/pipewire.conf

