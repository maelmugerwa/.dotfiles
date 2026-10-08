# plugins.zsh - loads zsh plugins from brew paths and a local directory

# Load the debug helpers once.
if [[ -f "$HOME/.config/zsh/debug.zsh" && -z "$ZSH_DEBUG_LOADED" ]]; then
  export ZSH_DEBUG_LOADED=1
  source "$HOME/.config/zsh/debug.zsh"
fi

if type zsh_debug &>/dev/null; then
  zsh_debug "Loading plugins.zsh"
fi

plugin_paths=(
  "/usr/local/share"
  "/opt/homebrew/share"
  "/home/linuxbrew/.linuxbrew/share"
)

# Source a plugin by name from the first path that holds it.
# Pass "silent" as the second argument to suppress the not-found warning.
load_plugin() {
  local plugin_name="$1"
  local plugin_found=0

  if type zsh_debug &>/dev/null; then
    zsh_debug "Attempting to load plugin: $plugin_name"
  fi

  for dir in "${plugin_paths[@]}"; do
    local plugin_path="$dir/$plugin_name/$plugin_name.zsh"
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

# Standard plugins
load_plugin "zsh-autosuggestions"   # Fish-like autosuggestions
load_plugin "zsh-syntax-highlighting" # Highlights syntax as you type
load_plugin "zsh-history-substring-search" # Searches history by substring

# History substring search keybindings.
# Terminals send different key codes, so bind each code.
# Standard keys
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Alternative keys for various terminals
bindkey '^[OA' history-substring-search-up      # xterm/gnome
bindkey '^[OB' history-substring-search-down    # xterm/gnome

# Ctrl+P and Ctrl+N work in every terminal.
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# vi command mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Return unique matches only.
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

if type log_keybindings &>/dev/null; then
  zsh_debug "Setting up history substring search keybindings"
  log_keybindings
fi

# Load more plugins here, for example:
# load_plugin "zsh-completions" # Additional completion definitions

# Local plugins
local_plugins_dir="$HOME/.dotfiles/zsh/plugins"
if [[ -d "$local_plugins_dir" ]]; then
  for plugin_file in "$local_plugins_dir"/*.zsh; do
    if [[ -f "$plugin_file" ]]; then
      local plugin_name=$(basename "$plugin_file" .zsh)

      zsh_debug "Before loading local plugin $plugin_name - PATH: $PATH"
      source "$plugin_file"
    fi
  done
fi
