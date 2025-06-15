# local.zsh - Machine-specific ZSH configurations
# This file is for settings unique to this machine
# It is NOT tracked in the dotfiles repository


# Extract Windows username from mounted drives (if in WSL)
# Default to current Linux username if unable to determine
WINDOWS_USERNAME=""
if [[ -d "/mnt/c/Users" ]]; then
  # Try to find the Windows username by checking for common directories
  for dir in /mnt/c/Users/*; do
    if [[ -d "$dir/AppData" ]]; then
      WINDOWS_USERNAME=$(basename "$dir")
      break
    fi
  done
  
  # If still empty, attempt to extract from $PATH
  if [[ -z "$WINDOWS_USERNAME" && "$PATH" == *"/mnt/c/Users/"* ]]; then
    WINDOWS_USERNAME=$(echo "$PATH" | sed -n 's/.*\/mnt\/c\/Users\/\([^\/]*\)\/.*/\1/p' | head -1)
  fi
  
  # Fallback to Linux username if still not found
  if [[ -z "$WINDOWS_USERNAME" ]]; then
    WINDOWS_USERNAME=$(whoami)
  fi
fi

# Set up PATH with priority order
typeset -U path  # Ensure PATH contains no duplicates
path=(
  $path                                    # Existing paths

  # Windows user-specific paths (using dynamic username)
  "/mnt/c/Users/${WINDOWS_USERNAME}/AppData/Local/Programs/oh-my-posh/bin"
  "/mnt/c/Users/${WINDOWS_USERNAME}/AppData/Local/Programs/Python/Python312/Scripts"
  "/mnt/c/Users/${WINDOWS_USERNAME}/AppData/Local/Programs/Python/Python312"
  "/mnt/c/Users/${WINDOWS_USERNAME}/AppData/Local/Programs/Python/Launcher"
  "/mnt/c/Users/${WINDOWS_USERNAME}/AppData/Local/Microsoft/WindowsApps"
  "/mnt/c/Users/${WINDOWS_USERNAME}/AppData/Local/Microsoft/WinGet/Links"
  "/mnt/c/Users/${WINDOWS_USERNAME}/AppData/Local/GitHubDesktop/bin"
  "/mnt/c/Users/${WINDOWS_USERNAME}/AppData/Roaming/npm"
  "/mnt/c/Users/${WINDOWS_USERNAME}/AppData/Local/Programs/Microsoft VS Code/bin"
  "/mnt/c/Users/${WINDOWS_USERNAME}/AppData/Local/Yarn/bin"
)

# Machine-specific environment variables
# export MY_LOCAL_VAR="/path/specific/to/this/machine"

# Machine-specific path additions
# path+=(
#   "$HOME/my-local-bin"       # Local binaries for this machine
#   "/opt/local/software/bin"  # Machine-specific software
# )

# Machine-specific aliases
# alias work="cd $HOME/projects/work"
# alias localdev="cd $HOME/dev/local-project"

# Machine-specific functions
# function local-backup() {
#   # Backup function specific to this machine
#   rsync -av --progress "$HOME/Documents/" "/mnt/backup/docs/"
# }

# Local tool configurations
# These override settings in tools.zsh

# Example: local mcfly configuration
# if command -v mcfly &> /dev/null; then
#   export MCFLY_RESULTS=30      # Show more results than default
# fi

# Load machine-specific secrets (API keys, tokens, etc.)
# if [[ -f "$HOME/.secrets" ]]; then
#   source "$HOME/.secrets"
# fi
