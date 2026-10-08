# amazon.zsh - Amazon-machine-only integrations.
#
# No-op on personal hosts (macOS, generic Linux, WSL). Detects either a
# Brazil/Apollo root or a Builder Toolbox install: a fresh Amazon Mac has no
# /apollo/env until Brazil creates its first workspace, but ~/.toolbox appears
# as soon as `axe init builder-tools` runs.
[[ -d /apollo/env || -d "$HOME/.toolbox" ]] || return 0

# Everything axe installs lands in ~/.toolbox/bin, which .zshenv already puts on
# PATH. Only the integrations used interactively need wiring here.

# Brazil CLI shell completion.
[[ -f "$HOME/.brazil_completion/zsh_completion" ]] && source "$HOME/.brazil_completion/zsh_completion"

# AIM CLI MCP servers.
[[ -d "$HOME/.aim/mcp-servers" ]] && path=("$HOME/.aim/mcp-servers" $path)

# MeshClaw CLI.
[[ -d "$HOME/MeshClaw/src/MeshClaw/bin" ]] && path=("$HOME/MeshClaw/src/MeshClaw/bin" $path)

# Eda completion. Regenerate only when missing or older than the eda binary:
# forking a toolbox binary on every shell start can stall on a self-update check.
if command -v eda &> /dev/null; then
  export EDA_AUTO="$HOME/.config/eda/completion"
  if [[ ! -f "$EDA_AUTO/_eda" || "$(command -v eda)" -nt "$EDA_AUTO/_eda" ]]; then
    mkdir -p "$EDA_AUTO"
    eda completions zsh > "$EDA_AUTO/_eda" 2>/dev/null
  fi
  fpath=("$EDA_AUTO" $fpath)
  # completion.zsh ran compinit before this file loaded, so extending fpath
  # alone registers nothing and `eda <TAB>` falls back to filenames.
  # Register the function directly. A second compinit also works but costs
  # 237 ms, against a 417 ms startup. `compinit -C` does not work at all:
  # it reuses the dump and never re-scans fpath.
  autoload -Uz _eda && compdef _eda eda 2>/dev/null
fi
