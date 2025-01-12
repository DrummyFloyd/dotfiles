############
## SETOPT ##
############
#
# History
HISTDUP=erase
setopt SHARE_HISTORY
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# autocd
setopt auto_cd

# Avoid no match found
setopt nomatch

############
## zstyle ##
############
#

# Autocomplete docker issue docker exec -it ..???
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# Completion ../
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(|.|..) ]] && reply=(..)'

# zstyle ':completion:*' special-dirs true
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Fuzzy matching of completions for when you mistype them
# https://man.archlinux.org/man/zsh-lovers.1
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 3 numeric

# ignore completion for function i dont have
zstyle ':completion:*:functions' ignored-patterns '_*'

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
