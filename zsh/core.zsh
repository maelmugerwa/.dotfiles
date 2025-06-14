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
