#!/usr/bin/env bash
CONFIG_DIR="$HOME/Config"

# Programs
doas emerge exa zsh dash xorg-server alsa-utils htop procs layman pass # system
doas emerge fzf rxvt-unicode neovim rust clangd black github-cli thefuck mcfly # dev
doas emerge mpv qutebrowser cmus tty-clock # applications
doas layman -a guru # many programs(zoxide)
doas layman -a vaacus # jedi-language-server
doas layman -a jjakob # gomuks
doas layman -a robertgzr # shfmt
doas layman -a ambasta # stylua
doas emerge pfetch zoxide bash-language-server lua-language-server gomuks stylua
cargo install himalaya
cd $CONFIG_DIR/Custom/applications/dmenu && doas make install &&
    \ cd ../../terminal/rover && doas make install &&
    \ cd ../../wm/dwm && doas make install &&
    \ cd ../slstatus && doas make install &&
    \ cd ../xorg/sx && doas make install && cd
cd $CONFIG_DIR/Other/nerd-fonts && ./install.sh

# Configs
cp $CONFIG_DIR/Other/asoundrc $HOME/.asoundrc

mkdir $HOME/.config/qutebrowser
cp -r $CONFIG_DIR/Custom/applications/qutebrowser/* $HOME/.config/qutebrowser

mkdir $HOME/.config/zsh
echo "source $CONFIG_DIR/Custom/terminal/zshrc" > $HOME/.config/zsh/.zshrc
doas cp $CONFIG_DIR/Custom/terminal/zshenv /etc/zsh/zshenv

mkdir $HOME/.config/htop
cp $CONFIG_DIR/Custom/terminal/htoprc $HOME/.config/htop/htoprc

mkdir $HOME/.config/nvim
cp -r $CONFIG_DIR/Custom/terminal/neovim/* $HOME/.config/nvim

doas mkdir /etc/X11/xorg.conf.d
doas cp -r $CONFIG_DIR/Custom/wm/xorg/xorg.conf.d/* /etc/X11/xorg.conf.d/

doas chsh -s /bin/zsh $USER

# doas nvidia-xconfig # if using a nvidia gpu
