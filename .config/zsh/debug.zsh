# debug.zsh - ZSH debugging and diagnostics utility

# Set up logging directory and file
ZSH_DEBUG_DIR="$HOME/.config/zsh-debug"
ZSH_DEBUG_FILE="$ZSH_DEBUG_DIR/zsh_debug.log"

# Create debug directory if it doesn't exist
if [[ ! -d "$ZSH_DEBUG_DIR" ]]; then
  mkdir -p "$ZSH_DEBUG_DIR"
  touch "$ZSH_DEBUG_FILE"
fi

# Debug logging function
zsh_debug() {
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$timestamp] $1" >> "$ZSH_DEBUG_FILE"
}

# Log header for new session
zsh_debug "========== NEW ZSH SESSION STARTED =========="
zsh_debug "User: $USER@$HOST"
zsh_debug "ZSH version: $ZSH_VERSION"
zsh_debug "Terminal: $TERM"
zsh_debug "Working directory: $PWD"

# Log path information
zsh_debug "PATH: $PATH"

# Function to check if a command exists and log the result
command_exists() {
  local cmd="$1"
  if command -v "$cmd" &> /dev/null; then
    zsh_debug "Command '$cmd' found at: $(command -v "$cmd")"
    return 0
  else
    zsh_debug "Command '$cmd' NOT FOUND"
    return 1
  fi
}

# Check key command availability
command_exists "starship"
command_exists "brew"

# Function to verify plugin loading
zsh_plugin_debug() {
  local plugin_name="$1"
  local plugin_path="$2"
  
  if [[ -f "$plugin_path" ]]; then
    zsh_debug "Plugin '$plugin_name' found at: $plugin_path"
  else
    zsh_debug "Plugin '$plugin_name' NOT FOUND at: $plugin_path"
  fi
}

# Log keybinding information
log_keybindings() {
  local tmp_file="$ZSH_DEBUG_DIR/keybindings.tmp"
  bindkey > "$tmp_file"
  zsh_debug "Current keybindings:"
  while read -r line; do
    zsh_debug "  $line"
  done < "$tmp_file"
  rm "$tmp_file"
}
