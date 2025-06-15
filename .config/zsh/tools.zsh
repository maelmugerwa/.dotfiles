# tools.zsh - External tool integrations
# This file handles setup and configuration of external tools

# Initialize zoxide (smarter cd command)
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# Initialize thefuck (command correction)
if command -v thefuck &> /dev/null; then
  eval "$(thefuck --alias)"
fi

# Initialize direnv (directory-specific environment variables)
if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# Initialize mcfly (smarter history search)
if command -v mcfly &> /dev/null; then
  # Set up mcfly before other tools to ensure it gets priority for keybindings
  export MCFLY_KEY_SCHEME=vim      # Use vim-style key bindings
  export MCFLY_FUZZY=true          # Enable fuzzy matching
  export MCFLY_RESULTS=20          # Show 20 results max
  export MCFLY_HISTORY_LIMIT=5000  # Remember this many commands
  export MCFLY_INTERFACE_VIEW=BOTTOM # Display at bottom of screen
  export MCFLY_DISABLE_MENU=false  # Keep the selection menu

  # Initialize mcfly
  eval "$(mcfly init zsh)"
fi

# FZF utilities (file finding, but not history search - using mcfly instead)
if command -v fzf &> /dev/null; then
  # Useful fzf shortcuts and helpers (but not history - that's handled by mcfly)
  alias fcd="cd \$(find . -type d | fzf)"                   # Interactive cd
  alias fopen="xdg-open \$(find . -type f | fzf)"           # Open file with default app
  alias ff="find . -type f | fzf"                          # Find files
  alias fd="find . -type d | fzf"                          # Find directories
  
  # FZF color and UI settings
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline"
  
  # Load fzf shell extensions, but don't let it bind Ctrl+R since we use mcfly
  if [[ -f ~/.fzf.zsh ]]; then
    # Temporarily disable Ctrl+R binding for fzf
    export FZF_CTRL_R_OPTS="--bind=ctrl-r:ignore"
    # Load fzf but make sure it doesn't override mcfly's Ctrl+R binding
    source ~/.fzf.zsh
    # Reset to avoid affecting other tools
    unset FZF_CTRL_R_OPTS
  fi
fi

# Initialize fnm (Fast Node Manager)
if command -v fnm &> /dev/null; then
  eval "$(fnm env --use-on-cd)"
fi

# Initialize pyenv (Python version manager)
if command -v pyenv &> /dev/null; then
  eval "$(pyenv init -)"
fi

# Initialize asdf (version manager)
if [[ -f /usr/local/opt/asdf/libexec/asdf.sh ]]; then
  source /usr/local/opt/asdf/libexec/asdf.sh
elif [[ -f $HOME/.asdf/asdf.sh ]]; then
  source $HOME/.asdf/asdf.sh
fi

# Add other tool initializations below this line
# Example:
# if command -v tool_name &> /dev/null; then
#   eval "$(tool_name init)"
# fi
