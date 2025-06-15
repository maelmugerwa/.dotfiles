# prompt.zsh - ZSH prompt configuration
# This file handles the setup of shell prompt using Starship

# Starship is a modern, fast, customizable cross-shell prompt
# Configuration is stored in ~/.config/starship.toml

# Disable Oh-My-ZSH theme if it's set (to prevent conflicts)
ZSH_THEME=""

# Initialize Starship prompt if available
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
# Fall back to a simple built-in prompt if Starship is not installed
else
  # Load promptinit module
  autoload -Uz promptinit
  promptinit
  
  # Use a simple built-in prompt
  PROMPT='%F{green}%n@%m%f:%F{blue}%~%f$ '
  
  # Display warning about missing Starship
  echo "Warning: Starship prompt not found. Using basic prompt instead." 
  echo "Install Starship for the full prompt experience: https://starship.rs/"
fi
