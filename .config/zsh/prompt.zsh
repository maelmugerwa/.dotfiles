# prompt.zsh - ZSH prompt configuration
# This file handles the setup of shell prompt using Starship

# Source debug utilities if it exists (but only once)
if [[ -f "$HOME/.config/zsh/debug.zsh" && -z "$ZSH_DEBUG_LOADED" ]]; then
  export ZSH_DEBUG_LOADED=1
  source "$HOME/.config/zsh/debug.zsh"
fi

# Log if debug functions are available
if type zsh_debug &>/dev/null; then
  zsh_debug "Loading prompt.zsh"
fi

# Starship is a modern, fast, customizable cross-shell prompt
# Configuration is stored in ~/.config/starship.toml

# Disable Oh-My-ZSH theme if it's set (to prevent conflicts)
ZSH_THEME=""

# First, explicitly check for Starship in all possible locations
STARSHIP_PATHS=(
  "/usr/local/bin/starship"
  "/opt/homebrew/bin/starship"
  "/home/linuxbrew/.linuxbrew/bin/starship"
  "$HOME/.local/bin/starship"
)

STARSHIP_PATH=""
for path in "${STARSHIP_PATHS[@]}"; do
  if [[ -x "$path" ]]; then
    STARSHIP_PATH="$path"
    if type zsh_debug &>/dev/null; then
      zsh_debug "Found Starship at: $STARSHIP_PATH"
    fi
    break
  fi
done

# If we couldn't find Starship in common locations, check PATH
if [[ -z "$STARSHIP_PATH" ]]; then
  if command -v starship &> /dev/null; then
    STARSHIP_PATH=$(command -v starship)
    if type zsh_debug &>/dev/null; then
      zsh_debug "Found Starship in PATH at: $STARSHIP_PATH"
    fi
  fi
fi

# Save the original PATH before initializing Starship
if [[ -n "$STARSHIP_PATH" ]]; then
  if type zsh_debug &>/dev/null; then
    zsh_debug "Initializing Starship prompt"
    zsh_debug "Starship config location: $XDG_CONFIG_HOME/starship.toml"
  fi
  
  # Important: Save the current PATH before calling starship
  local ORIGINAL_PATH="$PATH"
  
  # Capture any errors during initialization
  init_output=$("$STARSHIP_PATH" init zsh 2>&1)
  init_status=$?
  
  # Check if PATH was modified/corrupted by starship init
  if [[ "$PATH" != "$ORIGINAL_PATH" ]]; then
    if type zsh_debug &>/dev/null; then
      zsh_debug "WARNING: PATH was modified during starship initialization"
      zsh_debug "Original PATH: $ORIGINAL_PATH"
      zsh_debug "New PATH: $PATH"
    fi
    # Restore the original PATH
    export PATH="$ORIGINAL_PATH"
  fi
  
  if [[ $init_status -eq 0 ]]; then
    if type zsh_debug &>/dev/null; then
      zsh_debug "Starship initialized successfully"
    fi
    eval "$init_output"
  else
    if type zsh_debug &>/dev/null; then
      zsh_debug "ERROR: Starship initialization failed with status $init_status"
      zsh_debug "Starship error output: $init_output"
    fi
    # Fall back to simple prompt on starship init error
    PROMPT='%F{yellow}[STARSHIP ERROR]%f %F{green}%n@%m%f:%F{blue}%~%f$ '
    echo "Warning: Starship prompt initialization failed. Using basic prompt instead."
    echo "Starship error: $init_output"
  fi
# Fall back to a simple built-in prompt if Starship is not installed
else
  if type zsh_debug &>/dev/null; then
    zsh_debug "WARNING: Starship not found in PATH or common locations"
    zsh_debug "Current PATH: $PATH"
  fi

  # Load promptinit module
  autoload -Uz promptinit
  promptinit
  
  # Use a simple built-in prompt
  PROMPT='%F{green}%n@%m%f:%F{blue}%~%f$ '
  
  # Display warning about missing Starship
  echo "Warning: Starship prompt not found. Using basic prompt instead."
  echo "Install Starship for the full prompt experience: https://starship.rs/"
fi
