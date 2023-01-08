#!/usr/bin/env bash
# RUN AS ROOT
# EXPECTED TO HAVE gentoo-sources and linux-firmware installed
USER="moncheeta"
CONFIG_DIR="/home/$USER/config"
KERNEL_CONFIG="$CONFIG_DIR/gentoo/desktop-linux-6.1.2.config" # MUST SET!!!

# Portage
#cp -r $CONFIG_DIR/gentoo/portage/* /etc/portage # expected to already have done
emerge app-portage/cpuid2cpuflags
echo "*/* $(cpuid2cpuflags)" > /etc/portage/package.use/cpu
echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
emerge --verbose --update --deep --newuse @world

# Kernel
eselect kernel set 1 # select gentoo-sources
cp $KERNEL_CONFIG /usr/src/linux/.config
cd /usr/src/linux
make -j6
make modules_install
make install
cd
emerge os-prober
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Programs
emerge exa zsh xorg-server alsa-utils htop layman pass doas
\ ufw dhcpcd wpa_supplicant
\ fzf rxvt-unicode neovim rust clangd black github-cli mcfly
\ mpv qutebrowser cmus tty-clock # system, dev, and applications
layman -a guru # many programs(zoxide)
layman -a vaacus # jedi-language-server
layman -a jjakob # gomuks
layman -a robertgzr # shfmt
layman -a ambasta # stylua
emerge pfetch zoxide bash-language-server lua-language-server gomuks StyLua
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

mkdir /home/$USER/.config/nvim
cp -r $CONFIG_DIR/terminal/neovim/* /home/$USER/.config/nvim

mkdir /etc/X11/xorg.conf.d
cp -r $CONFIG_DIR/xorg/xorg.conf.d/* /etc/X11/xorg.conf.d/

chsh -s /bin/zsh $USER

# remember to run gh auth login when finished
# nvidia-xconfig # if using a nvidia gpu
