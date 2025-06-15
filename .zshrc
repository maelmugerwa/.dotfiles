# .zshrc - Main ZSH configuration file
# This file loads modular ZSH configuration from ~/.config/zsh
source "$HOME/.zshenv"

# Define base directory for ZSH configuration
ZDOTDIR=${ZDOTDIR:-$HOME}
ZSH_CONFIG_DIR="$HOME/.config/zsh"

# Load debug utility first if it exists (but only once)
if [[ -f "$ZSH_CONFIG_DIR/debug.zsh" && -z "$ZSH_DEBUG_LOADED" ]]; then
  export ZSH_DEBUG_LOADED=1
  source "$ZSH_CONFIG_DIR/debug.zsh"
  zsh_debug "Starting ZSH initialization (.zshrc)"
  zsh_debug "ZSH_CONFIG_DIR: $ZSH_CONFIG_DIR"
fi

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
  "local.zsh"     # Machine-specific configurations
)

# Source each config file if it exists
for config_file in "${zsh_config_files[@]}"; do
  config_path="$ZSH_CONFIG_DIR/$config_file"
  if [[ -f "$config_path" ]]; then
    if type zsh_debug &>/dev/null; then
      zsh_debug "Loading config file: $config_file"
    fi
    source "$config_path"
    source "$HOME/.zshenv"
    zsh_debug "PATH: $PATH"
  else
    if type zsh_debug &>/dev/null; then
      zsh_debug "Config file not found: $config_file"
    fi
  fi
done

zsh_debug "PATH before loading custom: $PATH"

# # Load any custom ZSH files from ~/.config/zsh that don't match the core files
# # This allows for additional customization without modifying core files
# for custom_file in "$ZSH_CONFIG_DIR"/*.zsh; do
#   # Skip files we already loaded
#   if [[ -f "$custom_file" ]]; then
#     basename=${custom_file:t}
#     if [[ ! " ${zsh_config_files[@]} " =~ " ${basename} " ]]; then
#       zsh_debug "Loading custom config file: $custom_file"
#       source "$custom_file"
#       source "$HOME/.zshenv"
#     fi
#   fi
# done

zsh_debug "PATH before cleanup: $PATH"

# Clean up
unset zsh_config_files
unset config_file
unset config_path
unset basename
unset custom_file

# Reset path 
source "$HOME/.zshenv"
zsh_debug "Resetting PATH to .zshenv"
zsh_debug "End PATH: $PATH"

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
