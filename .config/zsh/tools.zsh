# tools.zsh - external tool integrations.

# zoxide: smarter cd.
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# thefuck: command correction.
if command -v thefuck &> /dev/null; then
  eval "$(thefuck --alias)"
fi

# direnv: per-directory environment variables.
if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# mcfly: smarter history search.
if command -v mcfly &> /dev/null; then
  # Configure mcfly before the other tools so it wins the keybindings.
  export MCFLY_KEY_SCHEME=vim      # vim-style key bindings
  export MCFLY_FUZZY=true          # fuzzy matching
  export MCFLY_RESULTS=20          # show 20 results at most
  export MCFLY_HISTORY_LIMIT=5000  # remember this many commands
  export MCFLY_INTERFACE_VIEW=BOTTOM # show the menu at the bottom
  export MCFLY_DISABLE_MENU=false  # keep the selection menu

  eval "$(mcfly init zsh)"
fi

# fzf for file finding. mcfly owns history search.
if command -v fzf &> /dev/null; then
  # These aliases use `fd`, which respects FZF_EXCLUDES from fzf-cd.zsh.
  alias fcd='cd $(fd --type d --hidden --follow | fzf)'      # Interactive cd
  alias fopen='xdg-open $(fd --type f --hidden --follow | fzf)'  # Open file with default app
  alias ff='fd --type f --hidden --follow | fzf'             # Find files
  alias fdz='fd --type d --hidden --follow | fzf'            # Find directories (renamed from `fd` to avoid clashing with the fd binary)
  
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

# Initialize mise (single manager for node, python and go; rust is rustup's).
# Guarded on the command, not a path: brew installs it to different prefixes on
# macOS and Linux. Versions come from ~/.config/mise/config.toml.
if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
  [[ -f "$HOME/.local/share/mise/completions.zsh" ]] && source "$HOME/.local/share/mise/completions.zsh"
fi

# Add other tool initializations below this line
# Example:
# if command -v tool_name &> /dev/null; then
#   eval "$(tool_name init)"
# fi
