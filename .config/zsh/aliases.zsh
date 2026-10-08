# aliases.zsh - aliases for frequently used commands

# Modern CLI tool aliases
if command -v eza &> /dev/null; then
  # eza replaces ls.
  alias ls="eza --icons"                 # Basic listing with icons
  alias ll="eza -l --icons --git"        # Long listing with git status
  alias la="eza -la --icons --git"       # Show hidden files
  alias lt="eza -T --icons"              # Tree view
  alias lg="eza --git-ignore"            # Respect gitignore
fi

if command -v bat &> /dev/null; then
  # bat replaces cat.
  alias cat="bat --style=plain"          # Syntax-highlighted output
  alias catp="bat --plain"               # No line numbers or decorations
  alias bathelp="bat --plain --language=help" # For command help pages
fi

# No find alias. An alias breaks fzf, scripts and Makefiles that expect GNU find syntax.
# fd is already shorter than find.

if command -v rg &> /dev/null; then
  # ripgrep replaces grep.
  # The function falls back to real grep when rg rejects the regex.
  function grep {
    rg "$@" 2>/dev/null || command grep "$@"
  }
fi

if command -v nvim &> /dev/null; then
  # Neovim replaces Vim.
  alias vim="nvim"
  alias vi="nvim"
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
alias g="git"
alias gs="git status"
alias gl="git log"

# Terminal UI tools
alias lg="lazygit"                       # Terminal UI for git
alias ld="lazydocker"                    # Terminal UI for docker
alias top="btop"                         # Richer replacement for top

# JSON handling
alias jqp="jq '.'"                       # Pretty-print JSON
alias jqs="jq -r 'keys'"                 # Show JSON keys
alias jqv="jq -r '.[] | .'"              # Show JSON values

# HTTP client
alias GET="http GET"
alias POST="http POST"
alias HEAD="http HEAD"
alias httpj="http --json"                # Send a JSON content type

# Diff tool
alias diff="difft"                       # difftastic shows structural diffs

# Just - task runner
alias j="just"
alias jl="just --list"

# Add custom aliases below, for example:
# alias mycommand="complex command with options"

# MeshClaw
alias mc_dashboard='echo "http://localhost:7777 (SSH tunnel: ssh -L 7777:localhost:7777 $(hostname -f))"'
alias mc_restart='sudo systemctl restart meshclaw'
alias mc_tail='sudo journalctl -u meshclaw -f'
alias mc_status='sudo systemctl status meshclaw'
