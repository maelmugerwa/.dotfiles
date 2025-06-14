# Dotfiles

A comprehensive dotfiles repository managed by [yadm](https://yadm.io/) for quick and easy system setup across multiple machines.

## Quick Start

```bash
curl -fsSL https://raw.githubusercontent.com/maelmugerwa/.dotfiles/main/install.sh | bash
```

This one-line command will:
1. Install yadm if not already present
2. Clone this dotfiles repository
3. Run the bootstrap script to set up your environment
4. Install all tools and configurations

## Installation

### Prerequisites

- Git
- Curl
- A Unix-like environment (Linux, macOS, WSL)

### Manual Installation

1. Install yadm:
   ```bash
   # On macOS
   brew install yadm

   # On Ubuntu/Debian
   apt install yadm

   # On Fedora/RHEL
   dnf install yadm
   ```

2. Clone this repository:
   ```bash
   yadm clone https://github.com/maelmugerwa/.dotfiles.git
# Or using SSH:
# yadm clone git@github.com:maelmugerwa/.dotfiles.git
   ```

3. Run the bootstrap script:
   ```bash
   yadm bootstrap
   ```

## Repository Structure

```
.
├── .config/               # Configuration files
│   ├── yadm/             # yadm-specific configuration
│   ├── nvim/             # Neovim configuration
│   └── starship.toml     # Starship prompt configuration
├── docs/                 # Documentation files
│   ├── ALIASES.md        # All shell and git aliases
│   ├── EXTENDING.md      # How to extend dotfiles
│   └── TOOLS.md          # Included tool reference
├── homebrew/             # Homebrew related files
│   └── Brewfile          # Homebrew bundle file
├── yadm/                 # yadm scripts
│   ├── bootstrap         # Bootstrap script
│   └── setup-repo.sh     # GitHub repository setup
├── zsh/                  # ZSH configuration modules
│   ├── core.zsh          # Core ZSH settings
│   ├── completion.zsh    # Tab completion system
│   ├── prompt.zsh        # Prompt configuration
│   ├── plugins.zsh       # Plugin management
│   ├── aliases.zsh       # Command aliases
│   ├── tools.zsh         # External tool integrations
│   └── paths.zsh         # PATH and environment variables
├── .zshrc                # Main zsh loader
├── .gitconfig            # Git configuration
└── README.md             # This file
```

## Managing Your Dotfiles

### Making Changes

1. Edit any configuration file directly:
   ```bash
   vim ~/.dotfiles/zsh/aliases.zsh  # Edit aliases
   vim ~/.gitconfig                # Edit git config
   ```

2. For adding ZSH functionality:
   - Add to existing files in `zsh/` directory
   - Or create new `.zsh` files (they'll be loaded automatically)

3. For personal machine-specific settings:
   - Use `.zshrc.local` (not tracked by yadm)

### Pushing Updates

After making changes:

```bash
# Check what's changed
yadm status

# Stage and commit changes
yadm add <changed-files>
yadm commit -m "Description of changes"

# Push to remote repository
yadm push
```

### Pulling Updates on Other Machines

```bash
# Get latest changes 
yadm pull

# Update any tools/packages
yadm bootstrap
```

## Documentation

- [TOOLS.md](docs/TOOLS.md): Detailed information about all included tools
- [ALIASES.md](docs/ALIASES.md): Complete reference for all aliases (shell and git)
- [EXTENDING.md](docs/EXTENDING.md): Guide for extending and customizing dotfiles

## License

MIT
