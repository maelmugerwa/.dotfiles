# .zshenv - Environment setup for zsh
# This file loads BEFORE .zshrc and is used for all shell types
# Perfect for setting up base PATH and environment variables

# Set XDG directories early
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Ensure user bin directories exist
if [[ ! -d "$HOME/.local/bin" ]]; then
  mkdir -p "$HOME/.local/bin"
fi

# Ensure minimum PATH for core utilities
# This prevents "command not found" errors during initialization
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

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

# Set up Homebrew early
# This ensures Homebrew commands are available during zsh configuration
if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -d "/opt/homebrew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
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
