# prompt.zsh - ZSH prompt configuration
# This file handles the setup of shell prompts (starship or spaceship)

# Prompt setup priority:
# 1. Starship (modern, fast, customizable)
# 2. Spaceship (alternative if starship not available)
# 3. Basic built-in prompt (fallback)

# Try to load Starship prompt
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
  # Starship will use ~/.config/starship.toml automatically
  
# If no Starship, try Spaceship
elif command -v spaceship &> /dev/null; then
  # Spaceship prompt configuration
  SPACESHIP_PROMPT_ADD_NEWLINE=true
  SPACESHIP_CHAR_SYMBOL="⚡"
  SPACESHIP_BATTERY_SHOW=true
  SPACESHIP_BATTERY_THRESHOLD=20
  
  # Initialize spaceship
  source "$(brew --prefix)/opt/spaceship/spaceship.zsh"
  
# Fall back to a simple built-in prompt
else
  # Load promptinit module
  autoload -Uz promptinit
  promptinit
  
  # Use built-in prompt
  prompt adam1
  
  # Optionally add a custom basic prompt here if needed
  # PROMPT='%F{green}%n@%m%f:%F{blue}%~%f$ '
fi
