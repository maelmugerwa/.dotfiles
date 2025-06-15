# .zshrc - Main ZSH configuration file
# This file loads modular ZSH configuration from ~/.config/zsh

# Define base directory for ZSH configuration
ZDOTDIR=${ZDOTDIR:-$HOME}
ZSH_CONFIG_DIR="$HOME/.config/zsh"

# Load core ZSH configuration files
# Order matters here - load in dependency order
zsh_config_files=(
  # path-related settings now moved to ~/.zshenv
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

# Load any custom ZSH files from ~/.config/zsh that don't match the core files
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

# ===================================================================
# AUTO-ADDED CONTENT SECTION
# ===================================================================
# Tools may automatically append content below this line.
# When you notice new content here, consider moving it to the 
# appropriate module file in ~/.config/zsh/ for better organization:
#
# - For PATH additions:          → ~/.zshenv
# - For aliases/functions:       → aliases.zsh
# - For tool configurations:     → tools.zsh
# - For completion settings:     → completion.zsh
# - For core shell settings:     → core.zsh
# - For prompt configurations:   → prompt.zsh
# 
# Or create a new .zsh file for tool-specific configurations
# ===================================================================

# Content below will be preserved during updates
