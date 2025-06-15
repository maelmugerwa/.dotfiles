# .zshenv - Environment setup for zsh
# This file loads BEFORE .zshrc and is used for all shell types
# Perfect for setting up base PATH and environment variables

# Set XDG directories early
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Ensure user bin directories exist
if [[ ! -d "$HOME/.local/bin" ]]; then
  mkdir -p "$HOME/.local/bin"
fi

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

# Ensure minimum PATH for core utilities
# This prevents "command not found" errors during initialization
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# Set up PATH with priority order
typeset -U path  # Ensure PATH contains no duplicates
path=(
  "$HOME/.local/bin"                       # User binaries
  "$HOME/bin"                              # Legacy user binaries
  "/usr/local/bin"                         # Locally compiled software
  "/opt/homebrew/bin"                      # Homebrew on Apple Silicon
  "/usr/local/sbin"                        # Admin commands
  
  # WSL-specific paths for Windows interoperability
  "/mnt/c/Program Files/PowerShell/7"      # PowerShell
  "/mnt/c/Program Files/Alacritty"         # Alacritty terminal
  "/mnt/c/Program Files/Git/cmd"           # Git for Windows
  "/mnt/c/Program Files/dotnet"            # .NET Core
  "/mnt/c/Program Files/GitExtensions"     # Git Extensions
  "/mnt/c/Program Files/GitHub CLI"        # GitHub CLI
  "/mnt/c/Program Files/Neovim/bin"        # Neovim
  "/mnt/c/Program Files/nodejs"            # Node.js
  "/mnt/c/Program Files/Meld"              # Meld diff tool
  "/mnt/c/Program Files/Calibre2"          # Calibre
  "/mnt/c/Program Files (x86)/Yarn/bin"    # Yarn
  "/mnt/c/Program Files (x86)/Intel/iCLS Client"  # Intel components
  "/mnt/c/Program Files/Intel/iCLS Client"
  "/mnt/c/Program Files/Intel/WiFi/bin"
  "/mnt/c/Program Files/Common Files/Intel/WirelessCommon"
  "/mnt/c/Program Files (x86)/Intel/Intel(R) Management Engine Components/DAL"
  "/mnt/c/Program Files/Intel/Intel(R) Management Engine Components/DAL"
  "/mnt/c/Program Files (x86)/Intel/Intel(R) Management Engine Components/IPT"
  "/mnt/c/Program Files/Intel/Intel(R) Management Engine Components/IPT"
  
  # Windows system paths
  "/mnt/c/WINDOWS/system32"
  "/mnt/c/WINDOWS"
  "/mnt/c/WINDOWS/System32/Wbem"
  "/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0"
  "/mnt/c/WINDOWS/System32/OpenSSH"
  
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
  
  # Other paths
  "/mnt/c/ProgramData/chocolatey/bin"      # Chocolatey package manager
  "/mnt/c/Program Files/Docker/Docker/resources/bin"  # Docker
  
  # VSCode remote server path (dynamically changes)
  "$HOME/.vscode-server/bin/*/bin/remote-cli"
  
  "/usr/lib/wsl/lib"                       # WSL libs
  "/snap/bin"                              # Snap packages
  
  $path                                    # Existing paths
)

# Set up Homebrew early
# This ensures Homebrew commands are available during zsh configuration
if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -d "/opt/homebrew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Set editor based on availability
if command -v nvim &> /dev/null; then
  export EDITOR="nvim"
  export VISUAL="nvim"
elif command -v vim &> /dev/null; then
  export EDITOR="vim"
  export VISUAL="vim"
else
  export EDITOR="vi"
  export VISUAL="vi"
fi

# Language and locale settings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Terminal settings
export TERM="xterm-256color"  # Enhanced terminal colors

# Less settings
export LESS="-R"
export LESSHISTFILE=-  # Disable .lesshst file
