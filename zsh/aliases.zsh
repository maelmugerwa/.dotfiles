# aliases.zsh - Common command aliases and shortcuts
# This file contains aliases for frequently used commands

# Modern CLI tool aliases
if command -v eza &> /dev/null; then
  # eza - Modern replacement for ls
  alias ls="eza --icons"                 # Basic listing with icons
  alias ll="eza -l --icons --git"        # Long listing with git status
  alias la="eza -la --icons --git"       # Show hidden files
  alias lt="eza -T --icons"              # Tree view
  alias lg="eza --git-ignore"            # Respect gitignore
fi

if command -v bat &> /dev/null; then
  # bat - Modern replacement for cat
  alias cat="bat --style=plain"          # Better syntax highlighting
  alias catp="bat --plain"               # No line numbers or decorations
  alias bathelp="bat --plain --language=help" # For command help pages
fi

if command -v fd &> /dev/null; then
  # fd - Modern replacement for find
  alias find="fd"                        # Simpler syntax for finding files
fi

if command -v rg &> /dev/null; then
  # ripgrep - Modern replacement for grep
  alias grep="rg"                        # Faster searching in files
fi

if command -v nvim &> /dev/null; then
  # Neovim - Modern Vim
  alias vim="nvim"                       # Use Neovim instead of Vim
  alias vi="nvim"                        # Use Neovim instead of Vi
fi

# General navigation
alias c="clear"                          # Clear terminal screen
alias h="history"                        # Show command history
alias ..="cd .."                         # Go up one directory
alias ...="cd ../.."                     # Go up two directories
alias ....="cd ../../.."                 # Go up three directories
alias cd..="cd .."                       # Common typo fix

# File operations
alias mkdir="mkdir -p"                   # Create parent directories automatically
alias cp="cp -i"                         # Confirm before overwriting
alias mv="mv -i"                         # Confirm before overwriting
alias ln="ln -i"                         # Confirm before overwriting

# System aliases
alias df="df -h"                         # Human-readable sizes
alias du="du -h"                         # Human-readable sizes
alias free="free -m"                     # Show sizes in MB

# Git shortcuts
alias g="git"                            # Short git command
alias gs="git status"                    # Check git status
alias gl="git log"                       # View git log

# Add your custom aliases below this line
# Example:
# alias mycommand="complex command with options"
