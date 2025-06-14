# Dotfiles

Interactive setup for a complete development environment across Linux and macOS.

## Quick Installation

Interactive mode (recommended):
```bash
curl -fsSL https://raw.githubusercontent.com/maelmugerwa/.dotfiles/main/.config/install.sh | bash
```

Non-interactive mode:
```bash
curl -fsSL https://raw.githubusercontent.com/maelmugerwa/.dotfiles/main/.config/install.sh | bash -s -- --non-interactive
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

## License

MIT
