fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.cabal/bin

alias ls="exa -a"
alias ll="exa -al --git --no-time"
alias cp="cp -v"
alias mv="mv -v"
alias rm="trash"
alias bat="bat -n"
alias xplr="cls; xplr"
alias find="fzf"
alias cls="clear"
alias pause="read -n1 -r -p 'Press any key to continue...'"
alias clock="peaclock --config-dir ~/.config/peaclock"
alias rebo="doas reboot"
alias shut="doas poweroff"
alias mut="zellij"
alias mat="cmatrix"
alias sudo="doas"

# Git
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

# Other
alias mail="himalaya"
alias mark="glow"
alias spot="spotify"
alias wttr="curl wttr.in"

# Init
zoxide init fish | source
export CONFIG_DIR="~/Config"
export TERMINAL="urxvtc"

PF_INFO='ascii title os kernel memory' pfetch
