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

alias e="doas emerge --verbose --ask"
alias emerge="doas emerge --jobs=6 --load-average=6 --ask"
alias update="emerge --sync; doas emerge --jobs=6 --load-average=6 --ask --update --newuse --deep @world"
alias cleanup="doas emerge --deep --depclean; doas eclean -d distfiles"

alias conn="doas connmanctl"

# init
zoxide init fish | source
export CONFIG_DIR="$HOME/Config"
export TERMINAL="urxvtc"
export BROWSER="firefox"
export EDITOR="nvim"
export WALLPAPER="$CONFIG_DIR/Wallpapers/Gentoo/purple_logo.png"
export WIRELESS="wlp8s0"

PF_INFO='ascii title os kernel memory pkgs' pfetch

function fish_prompt
    echo -n '['(whoami)'@'(hostname)' '(prompt_pwd)']$ '
end

# other
export RXVT_SOCKET="/tmp/urxvt-socket"
