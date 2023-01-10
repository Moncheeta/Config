#!/usr/bin/env bash
# RUN AS ROOT
# EXPECTED TO HAVE gentoo-sources and linux-firmware installed
USER="moncheeta"
CONFIG_DIR="/home/$USER/config"
KERNEL_CONFIG="$CONFIG_DIR/gentoo/desktop-linux-6.1.2.config" # MUST SET!!!

# Portage
cp -r $CONFIG_DIR/gentoo/portage/* /etc/portage # expected to already have done
emerge app-portage/cpuid2cpuflags
echo "*/* $(cpuid2cpuflags)" > /etc/portage/package.use/cpu
emerge --verbose --update --deep --newuse @world

# Kernel
emerge os-prober
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Programs
emerge exa zsh xorg-server alsa-utils htop layman pass doas ufw dhcpcd wpa_supplicant
\ fzf ripgrep rxvt-unicode neovim rust ccls github-cli mcfly
\ mpv sxiv qutebrowser cmus tty-clock # system, dev programs, and programs
layman -a guru # many programs(zoxide, glow, pfetch)
layman -a jjakob # gomuks
emerge pfetch zoxide gomuks glow
cd $CONFIG_DIR/xorg/wm/dmenu && make install
cd ../dwm && make install
cd ../slstatus && make install
cd ../../sx && make install
cd ../../terminal/rover && make install
cd

# Services
rc-update add dhcpcd default
rc-update add wpa_supplicant default
rc-update add ufw default

# Configs
cp $CONFIG_DIR/gentoo/asoundrc /home/$USER/.asoundrc

mkdir /home/$USER/.config/qutebrowser
cp -r $CONFIG_DIR/other/qutebrowser/* /home/$USER/.config/qutebrowser

mkdir /home/$USER/.config/zsh
echo "source $CONFIG_DIR/terminal/zshrc" > /home/$USER/.config/zsh/.zshrc
cp $CONFIG_DIR/terminal/zshenv /etc/zsh/zshenv

mkdir /home/$USER/.config/htop
cp $CONFIG_DIR/terminal/htoprc /home/$USER/.config/htop/htoprc

git clone --depth 1 https://github.com/wbthomason/packer.nvim /home/$USER/.local/share/nvim/site/pack/packer/start/packer.nvim
mkdir /home/$USER/.config/nvim
cp -r $CONFIG_DIR/terminal/neovim/* /home/$USER/.config/nvim

mkdir /etc/X11/xorg.conf.d
cp -r $CONFIG_DIR/xorg/xorg.conf.d/* /etc/X11/xorg.conf.d/

chsh -s /bin/zsh $USER

# remember to run gh auth login when finished
# nvidia-xconfig # if using a nvidia gpu
