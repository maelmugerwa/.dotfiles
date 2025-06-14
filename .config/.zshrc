# .zshrc - Main ZSH configuration file
# This file loads modular ZSH configuration from ~/.dotfiles/zsh

# Define base directory for ZSH configuration
ZDOTDIR=${ZDOTDIR:-$HOME}
ZSH_CONFIG_DIR="$HOME/.dotfiles/.config/zsh"

# Load core ZSH configuration files
# Order matters here - load in dependency order
zsh_config_files=(
  "paths.zsh"     # Path and environment variables first
  "core.zsh"      # Core ZSH settings and options
  "completion.zsh" # Completion system
  "plugins.zsh"   # Plugin loading mechanism
  "prompt.zsh"    # Prompt configuration
  "tools.zsh"     # External tool integrations
  "aliases.zsh"   # Command aliases and shortcuts
)

# Source each config file if it exists
for config_file in "${zsh_config_files[@]}"; do
  config_path="$ZSH_CONFIG_DIR/$config_file"
  if [[ -f "$config_path" ]]; then
    source "$config_path"
  fi
done

# Load any custom ZSH files from .dotfiles/.config/zsh that don't match the core files
# This allows for additional customization without modifying core files
for custom_file in "$ZSH_CONFIG_DIR"/*.zsh; do
  # Skip files we already loaded
  if [[ -f "$custom_file" ]]; then
    basename=$(basename "$custom_file")
    if [[ ! " ${zsh_config_files[@]} " =~ " ${basename} " ]]; then
      source "$custom_file"
    fi
  fi
done

# Load local configurations if available (machine-specific)
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi

# Clean up
unset zsh_config_files
unset config_file
unset config_path
unset basename
unset custom_file
