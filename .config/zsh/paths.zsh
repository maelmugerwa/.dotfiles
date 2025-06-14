# paths.zsh - PATH and environment variable management
# This file sets up PATH and other environment variables

# XDG directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Ensure user bin directories exist and are in PATH
if [[ ! -d "$HOME/.local/bin" ]]; then
  mkdir -p "$HOME/.local/bin"
fi

# Set up PATH with priority order
typeset -U path  # Ensure PATH contains no duplicates
path=(
  "$HOME/.local/bin"                       # User binaries
  "$HOME/bin"                              # Legacy user binaries
  "/usr/local/bin"                         # Locally compiled software
  "/opt/homebrew/bin"                      # Homebrew on Apple Silicon
  "/usr/local/sbin"                        # Admin commands
  $path                                    # Existing paths
)

# Add homebrew to PATH if available
if [[ "$(uname -s)" == "Darwin" ]] && [[ "$(uname -m)" == "arm64" ]]; then
  # For Apple Silicon Macs
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  # For Intel Macs and Linux
  if [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

# Set editor based on availability
if command -v nvim &> /dev/null; then
  export EDITOR="nvim"
  export VISUAL="nvim"
elif command -v vim &> /dev/null; then
  export EDITOR="vim"
  export VISUAL="vim"
else
  export EDITOR="vi"
  export VISUAL="vi"
fi

# Language and locale settings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Less settings
export LESS="-R"
export LESSHISTFILE=-  # Disable .lesshst file

# Set any additional environment variables below this line
# Example:
# export MY_VARIABLE="value"
