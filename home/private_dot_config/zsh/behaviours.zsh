############
## SETOPT ##
############
#
# History
HISTDUP=erase
setopt SHARE_HISTORY
setopt appendhistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_expire_dups_first # Expire duplicate entries first when trimming history
setopt hist_reduce_blanks     # Remove superfluous blanks before recording entry
setopt hist_verify            # Don't execute immediately upon history expansion
setopt extended_history       # Write the history file in the ":start:elapsed;command" format

# autocd
setopt auto_cd

# Avoid no match found
setopt nomatch

# Misc
unsetopt beep
setopt extended_glob
setopt glob_dots
setopt interactive_comments

# Completion menu
setopt menu_complete    # Automatically highlight first element of completion menu
setopt auto_list        # Automatically list choices on ambiguous completion
setopt complete_in_word # Complete from both ends of a word

zle_highlight=('paste:none')
autoload -Uz colors && colors

##############
## compinit ##
##############
#
# INFO: must be before any compdef (fzf, completions sourced in exports.zsh)
# Full compinit (~150ms) only when dump is older than 24h, cached otherwise.
# Then stub it so plugins don't run it again.
zmodload zsh/complist
autoload -Uz compinit
_zcompdump=${ZDOTDIR:-$HOME}/.zcompdump
if [[ -n $_zcompdump(#qN.mh+24) ]]; then compinit; else compinit -C; fi
# Compile dump when (re)generated, source picks the newer .zwc automatically
if [[ -s $_zcompdump && ( ! -s $_zcompdump.zwc || $_zcompdump -nt $_zcompdump.zwc ) ]]; then
  zcompile $_zcompdump
fi
unset _zcompdump
compinit() { : }

# INFO: must be after compinit, which resets _comp_options
_comp_options+=(globdots) # With hidden files

############
## zstyle ##
############
#

# Autocomplete docker issue docker exec -it ..???
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# Completion ../
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(|.|..) ]] && reply=(..)'

# Fuzzy matching of completions for when you mistype them
# https://man.archlinux.org/man/zsh-lovers.1
zstyle ':completion:*' completer _extensions _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 3 numeric

# Case insensitive, then partial-word and substring completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# ignore completion for function i dont have
zstyle ':completion:*:functions' ignored-patterns '_*'

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Use cache for commands using cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

# Allow you to select in a menu
zstyle ':completion:*' menu yes select

# Complete the alias when _expand_alias is used as a function
zstyle ':completion:*' complete true
zle -C alias-expension complete-word _generic
zstyle ':completion:alias-expension:*' completer _expand_alias

# Autocomplete options for cd instead of directory stack
zstyle ':completion:*' complete-options true
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' keep-prefix true

# Automatically find new executables in path
zstyle ':completion:*' rehash true

# Colors for files and directory
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}

# Groups (named after the tags) and their formats
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'

# ssh/scp/rsync hosts from known_hosts
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
