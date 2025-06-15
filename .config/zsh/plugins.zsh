# plugins.zsh - ZSH plugin loading mechanism
# This file handles loading of ZSH plugins from various sources

# Source debug utility if it exists (but only once)
if [[ -f "$HOME/.config/zsh/debug.zsh" && -z "$ZSH_DEBUG_LOADED" ]]; then
  export ZSH_DEBUG_LOADED=1
  source "$HOME/.config/zsh/debug.zsh"
fi

# Log if debug functions are available
if type zsh_debug &>/dev/null; then
  zsh_debug "Loading plugins.zsh"
fi

# Define possible plugin locations
plugin_paths=(
  "/usr/local/share"
  "/opt/homebrew/share"
  "/home/linuxbrew/.linuxbrew/share"
)

# Function to load a plugin if it exists
load_plugin() {
  local plugin_name="$1"
  local plugin_found=0
  
  # Use debug function if available
  if type zsh_debug &>/dev/null; then
    zsh_debug "Attempting to load plugin: $plugin_name"
  fi
  
  for path in "${plugin_paths[@]}"; do
    local plugin_path="$path/$plugin_name/$plugin_name.zsh"
    if [[ -f "$plugin_path" ]]; then
      if type zsh_debug &>/dev/null; then
        zsh_debug "Loading plugin $plugin_name from $plugin_path"
      fi
      
      source "$plugin_path"
      plugin_found=1
      
      if type zsh_debug &>/dev/null; then
        zsh_debug "Successfully loaded plugin: $plugin_name"
      fi
      break
    fi
  done
  
  if [[ $plugin_found -eq 0 ]]; then
    if type zsh_debug &>/dev/null; then
      zsh_debug "WARNING: Plugin $plugin_name not found in configured paths"
    fi
    
    if [[ $2 != "silent" ]]; then
      zsh_debug "Warning: $plugin_name not found"
    fi
  fi
}

# Load standard plugins
load_plugin "zsh-autosuggestions"   # Fish-like autosuggestions
load_plugin "zsh-syntax-highlighting" # Syntax highlighting in the shell
load_plugin "zsh-history-substring-search" # Better history searching with up/down arrows

# Set up history substring search bindings
# Handle different terminal key codes
# Standard keys
bindkey '^[[A' history-substring-search-up      # Up arrow
bindkey '^[[B' history-substring-search-down    # Down arrow

# Alternative keys for various terminals
bindkey '^[OA' history-substring-search-up      # xterm/gnome
bindkey '^[OB' history-substring-search-down    # xterm/gnome

# Add Ctrl+P and Ctrl+N as alternatives that always work
bindkey '^P' history-substring-search-up        # Ctrl+P
bindkey '^N' history-substring-search-down      # Ctrl+N

# Also add to vi keymaps
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Vim key bindings
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Optional: ensure unique results
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# Log keybindings if debug utility is available
if type log_keybindings &>/dev/null; then
  zsh_debug "Setting up history substring search keybindings"
  log_keybindings
fi

# Additional plugins can be loaded here
# Examples:
# load_plugin "zsh-completions" # Additional completion definitions

# Check for plugins in custom locations
local_plugins_dir="$HOME/.dotfiles/zsh/plugins"
if [[ -d "$local_plugins_dir" ]]; then
  for plugin_file in "$local_plugins_dir"/*.zsh; do
    if [[ -f "$plugin_file" ]]; then
      # Extract plugin name from filename for logging
      local plugin_name=$(basename "$plugin_file" .zsh)
      
      zsh_debug "Before loading local plugin $plugin_name - PATH: $PATH" >> ~/path_debug.log
      source "$plugin_file"
    fi
  done
fi
