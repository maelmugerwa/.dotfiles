# Dotfiles

Interactive setup for a complete development environment across Linux, macOS, and WSL2.

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
- Delete repo_setup script; it is not needed on new machines
- Optional: move debug.zsh to its own folder so custom loaders do not auto-source it

## Troubleshooting
On new WSL2 install had to 
- Add zsh to approved shells `which zsh | sudo tee -a /etc/shells`
- Change default shell `chsh -s "$(which zsh)"`
- exit WSL and verify zsh
- Install correct node version `fnm install 20 && fnm use 20 && fnm default 20`
- Might need to update npm config if npm install fails `npm config set cache ~/.npm-cache --global && npm config set prefix ~/.npm-global --global`

## License

MIT
