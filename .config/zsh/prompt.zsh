# prompt.zsh - sets up the Starship prompt and a built-in fallback

# Load the debug helpers once.
if [[ -f "$HOME/.config/zsh/debug.zsh" && -z "$ZSH_DEBUG_LOADED" ]]; then
  export ZSH_DEBUG_LOADED=1
  source "$HOME/.config/zsh/debug.zsh"
fi

if type zsh_debug &>/dev/null; then
  zsh_debug "Loading prompt.zsh"
fi

# Starship reads its config from ~/.config/starship.toml.

# Clear any Oh-My-Zsh theme. A theme conflicts with Starship.
ZSH_THEME=""

# Look for Starship in the common install directories.
STARSHIP_PATHS=(
  "/usr/local/bin/starship"
  "/opt/homebrew/bin/starship"
  "/home/linuxbrew/.linuxbrew/bin/starship"
  "$HOME/.local/bin/starship"
)

STARSHIP_PATH=""
for candidate in "${STARSHIP_PATHS[@]}"; do
  if [[ -x "$candidate" ]]; then
    STARSHIP_PATH="$candidate"
    if type zsh_debug &>/dev/null; then
      zsh_debug "Found Starship at: $STARSHIP_PATH"
    fi
    break
  fi
done

# Fall back to PATH.
if [[ -z "$STARSHIP_PATH" ]]; then
  if command -v starship &> /dev/null; then
    STARSHIP_PATH=$(command -v starship)
    if type zsh_debug &>/dev/null; then
      zsh_debug "Found Starship in PATH at: $STARSHIP_PATH"
    fi
  fi
fi

if [[ -n "$STARSHIP_PATH" ]]; then
  if type zsh_debug &>/dev/null; then
    zsh_debug "Initializing Starship prompt"
    zsh_debug "Starship config location: $XDG_CONFIG_HOME/starship.toml"
  fi

  # Capture stderr as well, so a failed init stays reportable.
  init_output=$("$STARSHIP_PATH" init zsh 2>&1)
  init_status=$?

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
    # Starship init failed. Use a simple prompt.
    PROMPT='%F{yellow}[STARSHIP ERROR]%f %F{green}%n@%m%f:%F{blue}%~%f$ '
    echo "Warning: Starship prompt initialization failed. Using basic prompt instead."
    echo "Starship error: $init_output"
  fi
# Starship is absent. Use the built-in prompt.
else
  zsh_debug "WARNING: Starship not found in PATH or common locations"
  zsh_debug "Current PATH: $PATH"

  autoload -Uz promptinit
  promptinit

  PROMPT='%F{green}%n@%m%f:%F{blue}%~%f$ '

  echo "Warning: Starship prompt not found. Using basic prompt instead."
  echo "Install Starship for the full prompt experience: https://starship.rs/"
fi
