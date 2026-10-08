# .zshenv - environment for every zsh shell type.
# zsh loads this file before .zshrc. Set the base PATH and environment here.

# XDG base directories.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

# Copy the tracked templates when the machine-local files are missing.
# Both targets are gitignored.
if [[ ! -f "$HOME/.config/zsh/secrets.zsh" && -f "$HOME/.config/zsh/secrets.zsh.example" ]]; then
  cp "$HOME/.config/zsh/secrets.zsh.example" "$HOME/.config/zsh/secrets.zsh"
  chmod 600 "$HOME/.config/zsh/secrets.zsh"
fi
if [[ ! -f "$HOME/.config/zsh/local.zsh" && -f "$HOME/.config/zsh/local.zsh.example" ]]; then
  cp "$HOME/.config/zsh/local.zsh.example" "$HOME/.config/zsh/local.zsh"
fi

if [[ ! -d "$HOME/.local/bin" ]]; then
  mkdir -p "$HOME/.local/bin"
fi

# Guarantee the core utilities on PATH. A thin PATH breaks commands during init.
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# PATH in priority order. This works on Linux, macOS and WSL.
typeset -U path  # Drop duplicate PATH entries
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

# VS Code remote-cli. The glob stays unquoted and carries the (N) null-glob flag,
# so a no-match drops the entry. Quoting puts a literal '*' on PATH.
# An unquoted glob without (N) aborts .zshenv when nothing matches.
path=($HOME/.vscode-server/bin/*/bin/remote-cli(N) $path)

# WSL only: Windows interop paths. The guard keeps them off native Linux and macOS.
# The list holds the tools used from Linux. Add more /mnt/c entries here.
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

# Load Homebrew here so the later zsh config can call brew.
if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -d "/opt/homebrew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Pick the best editor the machine has.
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

# Locale. Prefer en_US.UTF-8 and fall back to C.UTF-8. A fresh Ubuntu or WSL
# without the `locales` package never generates en_US.UTF-8.
# Never pin LC_ALL. It forces one locale on every category and breaks setlocale()
# when that locale is absent.
if locale -a 2>/dev/null | grep -qiE '^en_US\.utf-?8$'; then
  export LANG=en_US.UTF-8
elif locale -a 2>/dev/null | grep -qiE '^C\.utf-?8$'; then
  export LANG=C.UTF-8
else
  unset LANG   # No UTF-8 locale exists. Drop a bad inherited value; C/POSIX applies.
fi
unset LC_ALL

# The terminal or tmux owns TERM. Set a fallback only when TERM is unset.
: "${TERM:=xterm-256color}"

# less settings.
export LESS="-R"
export LESSHISTFILE=-  # '-' disables the .lesshst file
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# uv / standalone-installer env file, when present.
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# Skip the EC2 instance metadata service. This stops the AWS CLI stalling on a
# metadata probe off EC2. Set it to false when you need IMDS.
export AWS_EC2_METADATA_DISABLED=true

# Machine-local secrets, such as tokens and keys. secrets.zsh is gitignored;
# see .config/zsh/.gitignore. .zshenv sources it so non-interactive shells,
# such as crons and spawned subagents, also get the exports.
[[ -f "$HOME/.config/zsh/secrets.zsh" ]] && source "$HOME/.config/zsh/secrets.zsh"
