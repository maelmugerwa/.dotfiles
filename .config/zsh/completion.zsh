# completion.zsh - tab completion for commands and options

autoload -Uz compinit
compinit

# Matching and display
zstyle ':completion:*' menu select              # Menu-style completion selection
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'm:{a-zA-Z}={A-Za-z} r:|[._-]=* r:|=*' 'm:{a-zA-Z}={A-Za-z} l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # Colorize completion lists
zstyle ':completion:*' verbose true             # Detailed completion information
zstyle ':completion:*' group-name ''            # Group matches by type
zstyle ':completion:*' completer _expand _complete _ignored  # No _approximate (conflicts with matcher-list fuzzy)

# Cache completions for speed.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# Completion behavior
zstyle ':completion:*:*:*:*:*' menu true
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,command'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*' special-dirs true        # Complete special directories (., .., ~)
