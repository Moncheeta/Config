# path
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin

set fish_greeting

# aliases
alias ls="exa -a"
alias ll="exa -al --git --no-time"
alias cp="cp -v"
alias mv="mv -v"
alias rm="trash -vf"
alias bat="bat -n"
alias find="fzf"
alias cls="clear; PF_INFO='ascii title os kernel memory pkgs' pfetch"
alias pause="read -n1 -r -p 'Press any key to continue...'"
alias reboot="doas reboot"
alias shut="doas poweroff"

alias sx="startx"
alias ss="gh screensaver -s starfield"
alias clock="peaclock --config='$HOME/Config/Custom/terminal/peaclock.conf'"
alias mat="cmatrix"
alias mail="himalaya"
alias wttr="curl wttr.in"
alias mark="glow"
alias present="lookatme"

alias repo="gh repo"
alias add="git add"
alias commit="git commit"
alias push="git push"
alias rebase="git rebase"
alias merge="git merge"
alias stat="git status"
alias notis="gh notify -arpw"
alias dash="gh status"
alias issue="gh issue"
alias pr="gh pr"
alias release="gh release"

# init
zoxide init fish | source
export CONFIG_DIR="$HOME/Config"
export TERMINAL="urxvtc"
export BROWSER="firefox"
export EDITOR="nvim"
export WALLPAPER="$CONFIG_DIR/Wallpapers/Gentoo/purple_logo.png"
export STARSHIP_CONFIG="$NIXOS_CONFIG_DIR/modules/programs/shell/starship.toml"

export RXVT_SOCKET="/tmp/urxvt-socket"

PF_INFO='ascii title os kernel memory pkgs' pfetch

starship init fish init | source
