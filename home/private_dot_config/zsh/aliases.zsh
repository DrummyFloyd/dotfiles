# Config File
alias nvimrc="nvim ${HOME}/.config/nvim/ --cmd ':cd %'"
alias dotfiles="nvim ${HOME}/.dotfiles --cmd ':cd %'"

# Color ip
alias ip="ip -c"
alias get-public-ip="dig +short myip.opendns.com @resolver1.opendns.com"

# color cat
alias cat="command -p bat --style=header,grid"

# histrory
alias history="history -Ei"

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='trash-put --'

# update-alternatives
alias change_python='sudo update-alternatives --config python3'

# git with extras
alias gdiff="git diff |ydiff"
alias glog="git log -p |ydiff"
alias ydiff-cached='git diff --cached | ydiff'
alias ydiff-show='git show | ydiff'
alias ydiff='ydiff -s -w 0'

# kubernetes
alias k="kubectl"
alias kx="kubectx"
alias kn="kubens"

# ram
alias ram-clear="free -h && sudo sysctl vm.drop_caches=3 && free -h"

# nvim
alias nv="nvim"
alias v="nvim"
alias :wq="echo ❌ Oopsi, your not in Vim 😄"

# systemd
alias list_systemctl_enabled="systemctl list-unit-files --state=enabled"
alias list_systemctl_disabled="systemctl list-unit-files --state=disabled"

# zsh alias specific
alias rsync="noglob rsync"
alias scp="noglob scp"

# Move dir
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -- -='cd -'

# pip glob issue
alias pip='noglob pip'

# Kitty ssh
if [[ $TERM == "xterm-kitty" ]]; then
  alias ssh="kitty +kitten ssh"
fi

# docker alias
alias docker-stop-all='docker rm -f $(docker ps -aq)'
alias docker-clean-all="docker system prune -a --volumes"

# terraform
alias tf="terraform"

# FIX: eza ll https://github.com/zap-zsh/exa/pull/12/files
alias ls='eza --group-directories-first --icons=auto'
