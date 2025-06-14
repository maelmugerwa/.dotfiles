# plugins.zsh - ZSH plugin loading mechanism
# This file handles loading of ZSH plugins from various sources

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
  
  for path in "${plugin_paths[@]}"; do
    local plugin_path="$path/$plugin_name/$plugin_name.zsh"
    if [[ -f "$plugin_path" ]]; then
      source "$plugin_path"
      plugin_found=1
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

# Additional plugins can be loaded here
# Examples:
# load_plugin "zsh-history-substring-search" # Better history searching with up/down arrows
# load_plugin "zsh-completions" # Additional completion definitions

# Check for plugins in custom locations
local_plugins_dir="$HOME/.dotfiles/zsh/plugins"
if [[ -d "$local_plugins_dir" ]]; then
  for plugin in "$local_plugins_dir"/*.zsh; do
    if [[ -f "$plugin" ]]; then
      source "$plugin"
    fi
  done
fi
