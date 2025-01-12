# User fav
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland
export EDITOR="nvim"
export TERMINAL="kitty"
export MANPAGER="nvim +Man!"
export TERM="xterm-kitty"

# History
HISTSIZE=10000
SAVEHIST=10000

# Forgit config
export FORGIT_LOG_GRAPH_ENABLE=false
export FORGIT_PAGER='delta --side-by-side -w ${FZF_PREVIEW_COLUMNS:-$COLUMNS}'

# FNM version
export ZSH_FNM_NODE_VERSION="lts/iron"      #v20
export ZSH_FNM_ENV_EXTRA_ARGS="--use-on-cd" # work with .node-version file in root project node --version > .node-version

# FZF options
# edited with https://vitormv.github.io/fzf-themes/
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:-1,fg+:#d0d0d0,bg:-1,bg+:#262626
  --color=hl:#5f87af,hl+:#5fd7ff,info:#afaf87,marker:#87ff00
  --color=prompt:#d7005f,spinner:#af5fff,pointer:#af5fff,header:#87afaf
  --color=gutter:#463f3f,border:#735e5e,scrollbar:#0e0e0e,label:#aeaeae
  --color=query:#d9d9d9
  --border="rounded" --border-label="" --preview-window="border-rounded" --prompt="> "
  --marker=">" --pointer="◆" --separator="─" --scrollbar="│"
  --bind ctrl-e:preview-down,ctrl-y:preview-up,ctrl-f:preview-half-page-down,ctrl-u:preview-half-page-up'
export FZF_CTRL_T_COMMAND="fd . -H --exclude .git -t f -t d || find ."
export FZF_PREVIEW_COMMAND="bat --color always {} || cat {} || tree -C {}"
export FZF_CTRL_T_OPTS="--border-label='Find Files' --ansi --min-height 90 --preview-window right:75%  --preview '($FZF_PREVIEW_COMMAND)  2> /dev/null'"
export FZF_ALT_C_COMMAND="fd -t d .|| find . -type d"
export FZF_ALT_C_OPTS="--border-label='Change Directory'"
export ZSH_FZF_HISTORY_SEARCH_FZF_EXTRA_ARGS=" --border-label=History_Search"

# Path append
## fnm init lts version
export PATH=${HOME}/.local/share/fnm:${PATH}
export PATH=${HOME}/.local/bin:${PATH} # python binaries
export PATH=${HOME}/bin:/usr/local/bin:${HOME}/.local/:${PATH}
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
[[ "$(command -v go)" ]] && export PATH=$PATH:$(go env GOPATH)/bin
[[ "$(command -v gem)" ]] && export PATH=$PATH:$(gem environment path):$(ruby -r rubygems -e 'puts Gem.user_dir')/bin

# INFO: fix issue /dev/fd/12:18: command not found: compdef error made by some completions below
autoload compinit
compinit

# Completion for command
# You can use whatever you want as an alias, like for Mondays:
# eval "`pip completion --zsh`"
eval $(thefuck --alias fock)
source <(fzf --zsh)
source <(garbage generate-completions zsh)
