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

`install.sh` shows a menu with three options:

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
- Optional: move debug.zsh to its own folder so custom loaders do not auto-source it

## Troubleshooting

A new WSL2 install needs these steps:
- Add zsh to approved shells `which zsh | sudo tee -a /etc/shells`
- Change default shell `chsh -s "$(which zsh)"`
- exit WSL and verify zsh
- Install the node version you need `mise use -g node@22`
- Might need to update npm config if npm install fails `npm config set cache ~/.npm-cache --global && npm config set prefix ~/.npm-global --global`

## Upgrading

`local.zsh` and `secrets.zsh` are machine-specific and gitignored. Your next
shell recreates each from its `.example` template if it is missing.

After a `yadm pull`, open a new shell or re-run bootstrap. Then re-add your real
values to `secrets.zsh`: tokens, `AC3_RC_HOST`, and corp cert variables.

## License

MIT
