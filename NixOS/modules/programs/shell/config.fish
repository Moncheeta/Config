# path
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.cabal/bin

set fish_greeting

# aliases
alias ls="exa -a"
alias ll="exa -al --git --no-time"
alias cp="cp -v"
alias mv="mv -v"
alias rm="trash"
alias bat="bat -n"
alias find="fzf"
alias cls="clear; PF_INFO='ascii title os kernel memory pkgs' pfetch"
alias pause="read -n1 -r -p 'Press any key to continue...'"
alias clock="peaclock --config-dir ~/.config/peaclock"
alias reboot="doas reboot"
alias shut="doas poweroff"
alias mat="cmatrix"
alias sx="startx herbstluftwm"
alias ss="gh screensaver starfield"
alias commit="git commit"
alias push="git push"
alias merge="git merge"
alias rebase="git rebase"
alias repo="gh repo"
alias add="git add"
alias stat="git status"
alias gstat="gh status"
alias pr="gh pr"
alias issue="gh issue"
alias release="gh release"
alias mail="himalaya"
alias mark="glow"
alias spot="spotify"
alias wttr="curl wttr.in"

# init
zoxide init fish | source
export CONFIG_DIR="~/Config"
export TERMINAL="urxvtc"
export BROWSER="firefox"
export EDITOR="nvim"

PF_INFO='ascii title os kernel memory pkgs' pfetch
