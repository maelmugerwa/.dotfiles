# .zshrc - interactive shell configuration.
# This file loads the modules in ~/.config/zsh.
# zsh sources ~/.zshenv first, so no explicit source belongs here.

ZDOTDIR=${ZDOTDIR:-$HOME}
ZSH_CONFIG_DIR="$HOME/.config/zsh"

# Load the debug helper once, before any module.
if [[ -f "$ZSH_CONFIG_DIR/debug.zsh" && -z "$ZSH_DEBUG_LOADED" ]]; then
  ZSH_DEBUG_LOADED=1
  source "$ZSH_CONFIG_DIR/debug.zsh"
  zsh_debug "Starting ZSH initialization (.zshrc)"
  zsh_debug "ZSH_CONFIG_DIR: $ZSH_CONFIG_DIR"
fi

# Core modules. Load them in dependency order.
zsh_config_files=(
  "core.zsh"      # Core ZSH settings and options
  "completion.zsh" # Completion system
  "plugins.zsh"   # Plugin loading mechanism
  "prompt.zsh"    # Prompt configuration
  "tools.zsh"     # External tool integrations
  "aliases.zsh"   # Command aliases and shortcuts
  "local.zsh"     # Machine-specific configurations
)

for config_file in "${zsh_config_files[@]}"; do
  config_path="$ZSH_CONFIG_DIR/$config_file"
  if [[ -f "$config_path" ]]; then
    if type zsh_debug &>/dev/null; then
      zsh_debug "Loading config file: $config_file"
    fi
    source "$config_path"
  else
    if type zsh_debug &>/dev/null; then
      zsh_debug "Config file not found: $config_file"
    fi
  fi
done

# Load every other .zsh module in the directory.
# This keeps the core files untouched.
for custom_file in "$ZSH_CONFIG_DIR"/*.zsh; do
  if [[ -f "$custom_file" ]]; then
    basename=${custom_file:t}
    if [[ ! " ${zsh_config_files[@]} " =~ " ${basename} " ]]; then
      if type zsh_debug &>/dev/null; then
        zsh_debug "Loading extra config file: $custom_file"
      fi
      source "$custom_file"
    fi
  fi
done

# Clean up
unset zsh_config_files
unset config_file
unset config_path
unset basename
unset custom_file

# ===================================================================
# AUTO-ADDED CONTENT SECTION
# ===================================================================
# Delete everything below this line. Nothing here is needed.
#
# Tools append content below this line. Move each new entry to the module
# that owns it:
#
# - PATH additions:          → ~/.zshenv
# - Aliases and functions:   → aliases.zsh
# - Tool configuration:      → tools.zsh
# - Completion settings:     → completion.zsh
# - Core shell settings:     → core.zsh
# - Prompt configuration:    → prompt.zsh
#
# For a new tool, create a new .zsh file in ~/.config/zsh.
# mise lives in tools.zsh. Amazon integrations live in amazon.zsh.
# PATH and environment variables live in ~/.zshenv.
# ===================================================================
