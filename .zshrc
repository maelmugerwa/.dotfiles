# .zshrc - Main ZSH configuration file
# This file loads modular ZSH configuration from ~/.config/zsh

# Add diagnostic logging for PATH issues
echo "=== ZSH PATH DIAGNOSTICS ===" > ~/path_debug.log
echo "Initial PATH: $PATH" >> ~/path_debug.log

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
  "local.zsh"     # Machine-specific configurations
)

# Source each config file if it exists
for config_file in "${zsh_config_files[@]}"; do
  config_path="$ZSH_CONFIG_DIR/$config_file"
  if [[ -f "$config_path" ]]; then
    echo "Before loading $config_file - PATH: $PATH" >> ~/path_debug.log
    source "$config_path"
    echo "After loading $config_file - PATH: $PATH" >> ~/path_debug.log
  fi
done

# Load any custom ZSH files from ~/.config/zsh that don't match the core files
# This allows for additional customization without modifying core files
echo "Before loading custom ZSH files - PATH: $PATH" >> ~/path_debug.log
for custom_file in "$ZSH_CONFIG_DIR"/*.zsh; do
  # Skip files we already loaded
  if [[ -f "$custom_file" ]]; then
    basename=${custom_file:t}
    if [[ ! " ${zsh_config_files[@]} " =~ " ${basename} " ]]; then
      echo "Before loading custom file $basename - PATH: $PATH" >> ~/path_debug.log
      source "$custom_file"
      echo "After loading custom file $basename - PATH: $PATH" >> ~/path_debug.log
    fi
  fi
done


# Clean up
echo "Before cleanup - PATH: $PATH" >> ~/path_debug.log
unset zsh_config_files
unset config_file
unset config_path
unset basename
unset custom_file
echo "After cleanup - PATH: $PATH" >> ~/path_debug.log

# Fix for PATH truncation issue
echo "Before re-sourcing .zshenv - PATH: $PATH" >> ~/path_debug.log
source ~/.zshenv
echo "After re-sourcing .zshenv - PATH: $PATH" >> ~/path_debug.log

# If PATH is still truncated, set it explicitly
if [[ "$PATH" == "/home/linuxbrew/.linuxbrew/share" || "$PATH" == *"/.linuxbrew/share"* ]]; then
  echo "PATH is truncated, applying fix" >> ~/path_debug.log
  export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.local/bin:$HOME/bin"
  
  # Re-add Homebrew paths if they exist
  if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
  fi
fi
echo "Final PATH: $PATH" >> ~/path_debug.log

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
