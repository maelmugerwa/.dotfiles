# core.zsh - Core ZSH settings and options
# This file contains fundamental ZSH settings like history, options, and keybindings

# History settings
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history

# Basic zsh settings
setopt autocd           # Change directory by typing directory name
setopt extendedglob     # Extended pattern matching capabilities
setopt nomatch          # Print error if pattern has no matches
setopt notify           # Report status of background jobs immediately
setopt interactive_comments  # Allow comments in interactive shell
unsetopt beep           # No beep on error

# Keybindings
bindkey -e              # Use emacs key bindings (more standard)

# Additional history options for better search experience
setopt hist_expire_dups_first # Delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_find_no_dups      # Do not display a line previously found
setopt hist_reduce_blanks     # Remove superfluous blanks before recording entry
setopt hist_verify            # Show command with history expansion before running it
