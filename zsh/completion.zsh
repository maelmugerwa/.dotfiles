# completion.zsh - ZSH completion system configuration
# This file sets up the tab completion system for commands and options

# Load completion system
autoload -Uz compinit
compinit

# Make completion system smarter
zstyle ':completion:*' menu select              # Menu-style completion selection
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case insensitive matching
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # Colorize completion lists
zstyle ':completion:*' verbose true             # Detailed completion information
zstyle ':completion:*' group-name ''            # Group matches by type
zstyle ':completion:*' completer _expand _complete _ignored _approximate  # Completion rules

# Cache completion for faster response
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# Completion behavior
zstyle ':completion:*:*:*:*:*' menu true
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,command'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*' special-dirs true        # Complete special directories (., .., ~)
