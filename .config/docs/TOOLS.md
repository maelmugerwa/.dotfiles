# Dotfiles - Tools Reference

This document describes each tool the dotfiles install and configure.

- [Package Management](#package-management)
- [Shell Configuration](#shell-configuration)
- [Modern CLI Tools](#modern-cli-tools)
- [Development Tools](#development-tools)
- [Terminal Productivity](#terminal-productivity)
- [Back to README](../README.md)

## Package Management

### Homebrew

[Homebrew](https://brew.sh/) is the package manager on macOS and Linux. One package list serves both platforms.

- **Brewfile**: `~/.config/homebrew/Brewfile` lists every package that setup installs.
- **Installation**: `install.sh` installs Homebrew on macOS and Linux.
- **Configuration**: The dotfiles set the Homebrew path per platform (Intel macOS, ARM macOS, or Linux).
- **Usage**: 
  ```bash
  brew install <package>     # Install a package
  brew upgrade               # Update all packages
  brew bundle --file=path    # Install packages from a Brewfile
  ```

## Shell Configuration

### Zsh

[Zsh](https://www.zsh.org/) config is modular. One file per concern:

- **Core config**: `.config/zsh/core.zsh` (history, options, keybindings)
- **Completion**: `.config/zsh/completion.zsh` (tab completion system)
- **Prompt**: `.config/zsh/prompt.zsh` (shell prompt settings)
- **Plugins**: `.config/zsh/plugins.zsh` (plugin loading)
- **Aliases**: `.config/zsh/aliases.zsh` (command shortcuts)
- **Tools**: `.config/zsh/tools.zsh` (external tool integration)
- **Paths**: `~/.zshenv` (PATH and environment variables)
- **Amazon**: `.config/zsh/amazon.zsh` (Amazon-host-only integrations)

### Starship Prompt

[Starship](https://starship.rs/) draws the shell prompt. It runs on any shell.

- **Config**: `.config/starship.toml`
- **Features**: Git status, Python and Node.js version, command duration

### Plugins

Zsh loads these plugins when they are present:

- **[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)**: Suggests commands from your history as you type
- **[zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)**: Colors commands as you type

## Modern CLI Tools

### bat

[bat](https://github.com/sharkdp/bat) replaces `cat`. It highlights syntax and reads Git state.

- **Usage**: `bat file.txt`. `cat` is aliased to `bat --style=plain`.
- **Features**: Syntax highlighting, line numbers, Git status column
- **Options**: `--plain` drops all decorations

### eza

[eza](https://github.com/eza-community/eza) replaces `ls`. It adds icons and Git state.

- **Usage**: `ls`, `ll`, `la`, `lt`, `lg` all map to `eza`
- **Features**: Icons, Git integration, color coding
- **Aliases**: `ls` (icons), `ll` (long plus Git), `la` (long plus hidden), `lt` (tree), `lg` (respects `.gitignore`)

### fd

[fd](https://github.com/sharkdp/fd) is a fast alternative to `find`.

- **Usage**: `fd pattern`. There is no alias. An alias on `find` breaks fzf, scripts and Makefiles that expect GNU `find` syntax.
- **Features**: Short syntax, respects `.gitignore`, colorized output

### ripgrep (rg)

[ripgrep](https://github.com/BurntSushi/ripgrep) searches file contents faster than `grep`.

- **Usage**: `rg pattern`. A `grep` shell function runs `rg` first and falls back to the real `grep` if `rg` fails.
- **Features**: Fast search, respects `.gitignore`, shows context

### zoxide

[zoxide](https://github.com/ajeetdsouza/zoxide) replaces `cd` with a ranked jump.

- **Usage**: `z directory-name`
- **Features**: Remembers directories you visit and matches them fuzzily

## Development Tools

### mise

[mise](https://mise.jdx.dev) manages Node, Python and Go versions. It replaces
fnm, pyenv and asdf, so there is one tool and one config file to learn.

Global versions live in the tracked `~/.config/mise/config.toml`. Every machine
converges on that file when `bootstrap` runs `mise install`.

- **Set the global default**: `mise use -g node@22`
- **Pin one directory**: `mise use node@18.20.2` (writes `./mise.toml`)
- **Run once without pinning**: `mise x node@18 -- npm ci`
- **List installed**: `mise ls`
- **List available**: `mise ls-remote node`

mise activates in `tools.zsh` and auto-switches when you cd into a directory
holding a `mise.toml` or `.tool-versions` file.

Rust is the exception: rustup owns it, and `~/.zshenv` sources `~/.cargo/env`.

### Git

The dotfiles ship a shared Git config, so every machine behaves the same.

- **Aliases**: See [ALIASES.md](ALIASES.md) for Git aliases
- **Configuration**: `.config/git/config`, with ignore rules in `.config/git/ignore`
- **Identity**: the untracked `~/.gitconfig` holds name and email, and wins on duplicate keys

### Neovim

[Neovim](https://neovim.io/) is a Vim fork with better defaults and async plugins.

- **Config**: `.config/nvim/`

## Terminal Productivity

### fzf (Fuzzy Finder)

[fzf](https://github.com/junegunn/fzf) filters any list interactively.

- **Usage**: `**` then Tab for path completion. See the FZF aliases in [ALIASES.md](ALIASES.md).
- **Features**: Fuzzy search over files, processes and any piped list
- **Note**: fzf does not own `Ctrl+R` here. `tools.zsh` keeps that binding for mcfly.

### mcfly

[mcfly](https://github.com/cantino/mcfly) replaces the default history search. `tools.zsh` initializes it and gives it `Ctrl+R`.

- **Usage**: `Ctrl+R`
- **Features**: Ranks history by context, fuzzy matching, vim keys
- **Settings**: `tools.zsh` exports `MCFLY_KEY_SCHEME`, `MCFLY_FUZZY`, `MCFLY_RESULTS`, `MCFLY_HISTORY_LIMIT` and `MCFLY_INTERFACE_VIEW`
- **Note**: The Brewfile keeps `atuin` commented out. mcfly covers shell history.

### lazygit

[lazygit](https://github.com/jesseduffield/lazygit) is a terminal UI for Git.

- **Usage**: `lazygit`, or the `lg` alias
- **Features**: Stage, commit, branch and rebase from one screen

### lazydocker

[lazydocker](https://github.com/jesseduffield/lazydocker) is a terminal UI for Docker.

- **Usage**: `lazydocker`, or the `ld` alias
- **Features**: Browse containers, images and logs from one screen
