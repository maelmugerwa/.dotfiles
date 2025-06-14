# tools.zsh - External tool integrations
# This file handles setup and configuration of external tools

# Initialize zoxide (smarter cd command)
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# Initialize thefuck (command correction)
if command -v thefuck &> /dev/null; then
  eval "$(thefuck --alias)"
fi

# Initialize direnv (directory-specific environment variables)
if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# Initialize atuin (better shell history)
if command -v atuin &> /dev/null && [ -f "$HOME/.zsh_atuin" ]; then
  source "$HOME/.zsh_atuin"
fi

# Initialize fnm (Fast Node Manager)
if command -v fnm &> /dev/null; then
  eval "$(fnm env --use-on-cd)"
fi

# Initialize pyenv (Python version manager)
if command -v pyenv &> /dev/null; then
  eval "$(pyenv init -)"
fi

# Initialize fzf (fuzzy finder)
if [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh
fi

# Initialize asdf (version manager)
if [[ -f /usr/local/opt/asdf/libexec/asdf.sh ]]; then
  source /usr/local/opt/asdf/libexec/asdf.sh
elif [[ -f $HOME/.asdf/asdf.sh ]]; then
  source $HOME/.asdf/asdf.sh
fi

# Add other tool initializations below this line
# Example:
# if command -v tool_name &> /dev/null; then
#   eval "$(tool_name init)"
# fi
