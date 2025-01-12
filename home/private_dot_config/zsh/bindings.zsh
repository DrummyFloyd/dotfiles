# Delete char
bindkey "^[[3~" delete-char

# [Ctrl-A/E] - move begining/ending of the cmd
bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line

# [Ctrl-RightArrow] - move forward one word
bindkey -M emacs '^[[1;5C' forward-word
bindkey -M viins '^[[1;5C' forward-word
bindkey -M vicmd '^[[1;5C' forward-word

# [Ctrl-LeftArrow] - move backward one word
bindkey -M emacs '^[[1;5D' backward-word
bindkey -M viins '^[[1;5D' backward-word
bindkey -M vicmd '^[[1;5D' backward-word

# [Ctrl-Delete] - delete whole forward-word
bindkey -M emacs '^[[3;5~' kill-word
bindkey -M viins '^[[3;5~' kill-word
bindkey -M vicmd '^[[3;5~' kill-word

# [Shift-Tab] - move through the completion menu backwards
bindkey -M emacs "${terminfo[kcbt]}" reverse-menu-complete
bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
