alias ls="exa -a"
alias ll="exa -al --git --no-time"
alias cp="cp -v"
alias mv="mv -v"
alias rm="trash"
alias bat="bat -n"
alias fm="xplr"
alias find="fzf"
alias cls="clear"
alias ping="pingu"
alias disk="lfs"
alias pause="read -n1 -r -p 'Press any key to continue...'"
alias clock="peaclock"
alias reboot="systemctl reboot"
alias shut="poweroff"
alias mut="zellij"
alias mat="cmatrix"

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
source $NIXOS_CONFIG_DIR/modules/scripts/himalaya.fish
zoxide init fish | source
PF_INFO='ascii title os kernel memory' pfetch
