# .zshenv - Environment setup for zsh
# This file loads BEFORE .zshrc and is used for all shell types
# Perfect for setting up base PATH and environment variables

# Set XDG directories early
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Seed machine-local files from their tracked templates when missing (first run,
# or after a pull that removed the old tracked local.zsh). Both are gitignored.
if [[ ! -f "$HOME/.config/zsh/secrets.zsh" && -f "$HOME/.config/zsh/secrets.zsh.example" ]]; then
  cp "$HOME/.config/zsh/secrets.zsh.example" "$HOME/.config/zsh/secrets.zsh"
  chmod 600 "$HOME/.config/zsh/secrets.zsh"
fi
if [[ ! -f "$HOME/.config/zsh/local.zsh" && -f "$HOME/.config/zsh/local.zsh.example" ]]; then
  cp "$HOME/.config/zsh/local.zsh.example" "$HOME/.config/zsh/local.zsh"
fi

# Ensure user bin directories exist
if [[ ! -d "$HOME/.local/bin" ]]; then
  mkdir -p "$HOME/.local/bin"
fi

# Ensure minimum PATH for core utilities
# This prevents "command not found" errors during initialization
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# Set up PATH with priority order (portable across Linux, macOS, WSL)
typeset -U path  # Ensure PATH contains no duplicates
path=(
  "$HOME/.local/bin"                       # User binaries
  "$HOME/.toolbox/bin"                     # Amazon toolbox-managed tools (axe, kiro-cli, etc.)
  "$HOME/bin"                              # Legacy user binaries
  "/usr/local/bin"                         # Locally compiled software
  "/usr/local/sbin"                        # Admin commands
  "/snap/bin"                              # Snap packages (Linux)
  $path                                    # Existing paths
)

# macOS only: Apple-Silicon Homebrew prefix.
[[ "$OSTYPE" == darwin* ]] && path=("/opt/homebrew/bin" $path)

# VS Code remote-cli: unquoted glob + (N) null-glob so a no-match drops the entry.
# (Quoting left a literal '*' in PATH; a bare unquoted no-match aborts .zshenv.)
path=($HOME/.vscode-server/bin/*/bin/remote-cli(N) $path)

# WSL only: Windows interop paths. Guarded so they never load on native Linux/macOS.
# Trimmed to tools used from Linux; add more under /mnt/c here as needed.
if [[ -n "$WSL_DISTRO_NAME" ]]; then
  path+=(
    "/mnt/c/Program Files/PowerShell/7"
    "/mnt/c/Program Files/Git/cmd"
    "/mnt/c/Program Files/nodejs"
    "/mnt/c/Program Files (x86)/Yarn/bin"
    "/mnt/c/Program Files/Docker/Docker/resources/bin"
    "/mnt/c/WINDOWS/system32"
    "/mnt/c/WINDOWS"
    "/mnt/c/WINDOWS/System32/Wbem"
    "/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0"
    "/mnt/c/WINDOWS/System32/OpenSSH"
    "/usr/lib/wsl/lib"
  )
fi

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

# Language and locale. Prefer en_US.UTF-8; fall back to C.UTF-8 if it was never
# generated (fresh Ubuntu/WSL without the `locales` package). Never hard-pin
# LC_ALL: it forces a possibly-missing locale on every category, breaking setlocale().
if locale -a 2>/dev/null | grep -qiE '^en_US\.utf-?8$'; then
  export LANG=en_US.UTF-8
elif locale -a 2>/dev/null | grep -qiE '^C\.utf-?8$'; then
  export LANG=C.UTF-8
else
  unset LANG   # neither locale exists; clear any bad inherited value (falls to C/POSIX)
fi
unset LC_ALL

# TERM belongs to the terminal/tmux; set a fallback only when it is unset.
: "${TERM:=xterm-256color}"

# Less settings
export LESS="-R"
export LESSHISTFILE=-  # Disable .lesshst file
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# Added by AIM CLI
export PATH="$HOME/.aim/mcp-servers:$PATH"

# Machine-local secrets (tokens, keys) kept out of version control.
# secrets.zsh is gitignored (see .config/zsh/.gitignore). Sourced here so
# non-interactive shells (crons, spawned subagents) get the exports too.
[[ -f "$HOME/.config/zsh/secrets.zsh" ]] && source "$HOME/.config/zsh/secrets.zsh"
