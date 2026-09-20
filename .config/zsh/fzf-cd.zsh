# fzf-cd.zsh — fzf-powered directory navigation
# Ctrl+R stays with mcfly (see tools.zsh). This module only adds cd helpers.

# Shared exclusion list for all fuzzy file/dir searches
# Add more patterns here once — used by fzf (Ctrl+T, Alt+C) and cdp
FZF_EXCLUDES=(.git node_modules brazil-pkg-cache build dist target .venv __pycache__)
_fzf_fd_excludes=(); for e in $FZF_EXCLUDES; do _fzf_fd_excludes+=(--exclude $e); done

# Make fzf's default pickers (Ctrl+T, Alt+C) use fd with our excludes
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow ${_fzf_fd_excludes[*]}"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow ${_fzf_fd_excludes[*]}"

# Populate `dirs -v` automatically so `cdf` has a stack to jump through
setopt AUTO_PUSHD          # every cd acts like pushd
setopt PUSHD_IGNORE_DUPS   # no duplicates in the stack
setopt PUSHD_SILENT        # don't print the stack on every cd

# Load fzf's zsh completion + Alt-C widget, but NOT its Ctrl+R binding
if command -v fzf &> /dev/null; then
  source <(fzf --zsh)
  # fzf --zsh re-binds Ctrl+R to fzf-history-widget; restore mcfly ownership
  if command -v mcfly &> /dev/null; then
    bindkey '^R' mcfly-history-widget
  fi
fi

# cdf — jump to a previously visited directory via fzf
cdf() {
  local dir
  dir=$(dirs -v | fzf --height 40% --reverse | awk '{print $2}') || return
  [[ -n $dir ]] && cd "${dir/#\~/$HOME}"
}

# cdp — fuzzy cd with partial path match (fd + fzf)
# Usage: cdp            → search from $HOME
#        cdp foo        → search from $HOME for dirs matching "foo"
#        cdp . bar      → search from CWD for dirs matching "bar"
cdp() {
  local root="${1:-$HOME}" query="${2:-}"
  [[ $# -eq 1 && $1 != /* && $1 != . && ! -d $1 ]] && { query="$1"; root="$HOME"; }
  local dir
  dir=$(command fd --type d --hidden --follow ${_fzf_fd_excludes[@]} . "$root" \
        | fzf --height 40% --reverse --query "$query" --select-1 --exit-0) || return
  cd "$dir"
}

# fzf **<TAB> completion generators — use fd instead of GNU find
_fzf_compgen_path() {
  command fd --hidden --follow ${_fzf_fd_excludes[@]} . "$1"
}
_fzf_compgen_dir() {
  command fd --type d --hidden --follow ${_fzf_fd_excludes[@]} . "$1"
}
