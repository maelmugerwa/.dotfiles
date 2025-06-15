# Dotfiles

Interactive setup for a complete development environment across Linux and macOS.

## Quick Installation

Interactive mode (recommended):
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/maelmugerwa/.dotfiles/main/.config/install.sh)"
```

Non-interactive mode:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/maelmugerwa/.dotfiles/main/.config/install.sh)" -- --non-interactive
```

## Management Features

The installation script provides an interactive menu with options to:

1. **Install dotfiles** (standard installation)
   - Install Homebrew (macOS & Linux)
   - Install YADM via Homebrew
   - Clone dotfiles repository
   - Run bootstrap script

2. **Cleanup previous installation**
   - Remove YADM via Homebrew
   - Clean YADM repository data

3. **Restore from backup**
   - List available backups with timestamps
   - Select and restore from previous backups

## Features

- Interactive installation management menu
- Modern shell configuration with zsh
- Powerful CLI tools (bat, ripgrep, fd, etc.)
- Development environment setup
- Sensible defaults for Git and command line
- Cross-platform compatibility (Linux, macOS)
- Homebrew installation for both macOS and Linux
- Backup and restore capabilities

## Documentation

- [Tools Reference](.config/docs/TOOLS.md)
- [Aliases Reference](.config/docs/ALIASES.md)
- [Customization Guide](.config/docs/EXTENDING.md)
- [YADM Guide](.config/docs/YADM.md)

## TODO
- Cleanup local.zsh & .zshenv to better handle WSL. Should hopefully retrieve bash or windows path and through var instead
- Cleanup debug.zsh to not use shell commands which might not be available
- Find a cleaner solution to avoid having to source .zshenv after each zsh config load
- Re-enable debug.zsh in plugins.zsh
- Delete repo_setup script as it's not needed on new machines
- Move debug.zsh to its own folder to avoid it being loaded through custom loaders in .zshrc
- Fix local.zsh currently tracked in git

## License

MIT
