# Dotfiles - Tools Reference

This document provides detailed information about the tools included in these dotfiles.

- [Package Management](#package-management)
- [Shell Configuration](#shell-configuration)
- [Modern CLI Tools](#modern-cli-tools)
- [Development Tools](#development-tools)
- [Terminal Productivity](#terminal-productivity)
- [Back to README](../README.md)

## Package Management

### Homebrew

[Homebrew](https://brew.sh/) is the package manager used for both macOS and Linux. It allows for consistent package management across different platforms.

- **Brewfile**: Located at `~/.config/homebrew/Brewfile`, it contains all packages to be installed during setup.
- **Installation**: Handled automatically by the bootstrap script.
- **Usage**: 
  ```bash
  brew install <package>     # Install a package
  brew upgrade               # Update all packages
  brew bundle --file=path    # Install packages from a Brewfile
  ```

## Shell Configuration

### Zsh

[Zsh](https://www.zsh.org/) is configured with a modular approach:

- **Core config**: Located in `.config/zsh/core.zsh` (history, options, keybindings)
- **Completion**: Located in `.config/zsh/completion.zsh` (tab completion system)
- **Prompt**: Located in `.config/zsh/prompt.zsh` (shell prompt settings)
- **Plugins**: Located in `.config/zsh/plugins.zsh` (plugin loading)
- **Aliases**: Located in `.config/zsh/aliases.zsh` (command shortcuts)
- **Tools**: Located in `.config/zsh/tools.zsh` (external tool integration)
- **Paths**: Located in `.config/zsh/paths.zsh` (PATH and env variables)

### Starship Prompt

[Starship](https://starship.rs/) is a minimal, fast, and customizable prompt for any shell:

- **Config**: Located at `.config/starship.toml`
- **Features**: Git status, Python/Node.js version, command duration, etc.
- **Benefits**: Works across different shells, minimal configuration

### Plugins

The following Zsh plugins are automatically loaded if available:

- **[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)**: Fish-like command suggestions based on history
- **[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)**: Syntax highlighting for commands as you type

## Modern CLI Tools

### bat

[bat](https://github.com/sharkdp/bat) is a `cat` clone with syntax highlighting and Git integration:

- **Usage**: `bat file.txt` (aliased to `cat`)
- **Features**: Syntax highlighting, line numbers, Git status integration
- **Options**: `--plain` for simple output without decorations

### eza

[eza](https://github.com/eza-community/eza) is a modern replacement for `ls`:

- **Usage**: `eza` (aliased to `ls`), `ll`, `la`, `lt`
- **Features**: Icons, Git integration, color coding
- **Options**: Various aliases for different listing formats

### fd

[fd](https://github.com/sharkdp/fd) is a simple, fast alternative to `find`:

- **Usage**: `fd pattern` (aliased to `find`)
- **Features**: Intuitive syntax, respects `.gitignore`, colorized output
- **Benefits**: Much simpler syntax than traditional `find`

### ripgrep (rg)

[ripgrep](https://github.com/BurntSushi/ripgrep) is a faster alternative to grep:

- **Usage**: `rg pattern` (aliased to `grep`)
- **Features**: Fast search, respects `.gitignore`, shows context
- **Benefits**: Much faster than traditional grep, prettier output

### zoxide

[zoxide](https://github.com/ajeetdsouza/zoxide) is a smarter cd command:

- **Usage**: `z directory-name`
- **Features**: Remembers directories you visit, allows fuzzy matching
- **Benefits**: Much faster navigation between commonly used directories

## Development Tools

### fnm (Fast Node Manager)

[fnm](https://github.com/Schniz/fnm) is a fast and simple Node.js version manager:

- **Usage**: `fnm use 16` or `fnm use`
- **Features**: Automatically switches Node.js versions based on `.nvmrc` files
- **Benefits**: Much faster than nvm, works with various shells

### pyenv

[pyenv](https://github.com/pyenv/pyenv) is a Python version manager:

- **Usage**: `pyenv install 3.10.0`, `pyenv global 3.10.0`
- **Features**: Manage multiple Python versions
- **Benefits**: Isolate Python environments per project

### Git

Git is extensively configured with useful aliases and settings:

- **Aliases**: See [ALIASES.md](ALIASES.md) for Git aliases
- **Configuration**: Located in `.gitconfig`
- **Benefits**: Consistent Git workflow across machines

### Neovim

[Neovim](https://neovim.io/) is a modern, improved version of Vim:

- **Config**: Configuration may be located in `.config/nvim/`
- **Benefits**: Better defaults, improved plugin system, async operations

## Terminal Productivity

### fzf (Fuzzy Finder)

[fzf](https://github.com/junegunn/fzf) is a general-purpose command-line fuzzy finder:

- **Usage**: `Ctrl+R` for history search, `**` tab completion, etc.
- **Features**: Fast fuzzy search for files, history, processes, etc.
- **Benefits**: Makes finding things in the terminal much faster

### atuin

[atuin](https://github.com/atuinsh/atuin) is a magical shell history tool:

- **Usage**: `Ctrl+R` (replaces default history search)
- **Features**: Searchable shell history with context, syncing between machines
- **Benefits**: Never lose command history, search by context

### lazygit

[lazygit](https://github.com/jesseduffield/lazygit) is a terminal UI for git commands:

- **Usage**: `lazygit`
- **Features**: Visual interface for common Git operations
- **Benefits**: Simplifies complex Git operations

### lazydocker

[lazydocker](https://github.com/jesseduffield/lazydocker) is a terminal UI for docker:

- **Usage**: `lazydocker`
- **Features**: Visual interface for Docker containers, images, etc.
- **Benefits**: Simplifies managing Docker resources
