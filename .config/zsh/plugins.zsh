# plugins.zsh - ZSH plugin loading mechanism
# This file handles loading of ZSH plugins from various sources

# Add diagnostic logging - Uncomment to debug PATH issues
# echo "plugins.zsh start - PATH: $PATH" >> ~/path_debug.log

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
  local original_path="$PATH"  # Save original PATH
  
  # echo "Before loading plugin $plugin_name - PATH: $PATH" >> ~/path_debug.log
  
  for path in "${plugin_paths[@]}"; do
    local plugin_path="$path/$plugin_name/$plugin_name.zsh"
    if [[ -f "$plugin_path" ]]; then
      source "$plugin_path"
      plugin_found=1
      
      # Check if PATH was completely overwritten (instead of appended to)
      # This handles both corruption and legitimate additions
      if [[ "$PATH" != *"$original_path"* && "$PATH" != "$original_path"* ]]; then
        # Instead of just restoring, we'll merge the paths
        # New paths the plugin might have added + our original paths
        export PATH="$PATH:$original_path"
        # Remove duplicates while preserving order
        typeset -U PATH
        # echo "Fixed PATH after loading $plugin_name plugin" >> ~/path_debug.log
      fi
      
      # echo "After loading plugin $plugin_name from $plugin_path - PATH: $PATH" >> ~/path_debug.log
      break
    fi
  done
  
  if [[ $plugin_found -eq 0 && $2 != "silent" ]]; then
    echo "Warning: $plugin_name not found"
  fi
}

# Load standard plugins
load_plugin "zsh-autosuggestions"   # Fish-like autosuggestions
load_plugin "zsh-syntax-highlighting" # Syntax highlighting in the shell
load_plugin "zsh-history-substring-search" # Better history searching with up/down arrows

# Set up history substring search bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Optional: ensure unique results
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

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
      local original_path="$PATH"
      
      # echo "Before loading local plugin $plugin_name - PATH: $PATH" >> ~/path_debug.log
      source "$plugin_file"
      
      # Apply the same PATH protection as in load_plugin
      if [[ "$PATH" != *"$original_path"* && "$PATH" != "$original_path"* ]]; then
        # Merge paths and remove duplicates
        export PATH="$PATH:$original_path"
        typeset -U PATH
        # echo "Fixed PATH after loading local plugin $plugin_name" >> ~/path_debug.log
      fi
      # echo "After loading local plugin $plugin_name - PATH: $PATH" >> ~/path_debug.log
    fi
  done
fi
