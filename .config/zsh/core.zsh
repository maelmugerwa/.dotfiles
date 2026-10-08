# core.zsh - history, shell options and keybindings

# History settings
HISTFILE=$HOME/.zsh_history
# McFly and history-substring-search read HISTFILE at init. zsh only creates
# it on first write, so a fresh machine has nothing for them to read.
[[ -f "$HISTFILE" ]] || { touch "$HISTFILE"; chmod 600 "$HISTFILE"; }
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history

# Shell options
setopt autocd           # Change directory by typing directory name
setopt extendedglob     # Extended pattern matching
setopt nomatch          # Print an error if a pattern has no matches
setopt notify           # Report background job status immediately
setopt interactive_comments  # Allow comments in an interactive shell
unsetopt beep           # No beep on error

# Keybindings
bindkey -e              # emacs key bindings

# More history options
setopt hist_expire_dups_first # Delete duplicates first when HISTFILE exceeds HISTSIZE
setopt hist_find_no_dups      # Do not display a line found before
setopt hist_reduce_blanks     # Remove extra blanks before recording an entry
setopt hist_verify            # Show the expanded command before running it
