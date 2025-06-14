# YADM Management Guide

This document covers advanced management tasks for yadm (Yet Another Dotfiles Manager), including setup, troubleshooting, and testing procedures.

## Table of Contents
- [Structure Overview](#structure-overview)
- [Initial Setup](#initial-setup)
- [Testing the Setup](#testing-the-setup)
- [Troubleshooting](#troubleshooting)
- [Advanced Operations](#advanced-operations)
- [Back to README](../README.md)

## Structure Overview

The dotfiles are organized following the XDG Base Directory Specification:

```
$HOME/
├── .zshrc                # Main ZSH configuration entry point
└── .config/              # XDG-compliant configuration directory
    ├── docs/             # Documentation
    ├── homebrew/         # Homebrew bundle files
    │   └── Brewfile      # Used by 'brew bundle --global'
    ├── yadm/             # YADM configuration
    │   ├── bootstrap     # Bootstrap script executed by 'yadm bootstrap'
    │   └── setup-repo.sh # Helper to set up GitHub repository
    └── zsh/              # ZSH modular configuration
        ├── aliases.zsh   # Command aliases and shortcuts
        ├── completion.zsh # Completion system
        ├── core.zsh      # Core ZSH settings
        └── ...           # Other ZSH configuration files
```

## Initial Setup

The initial setup is handled by `install.sh`, which provides an interactive menu with several options:

1. **Install dotfiles** (standard installation):
   - Installs Homebrew on both macOS and Linux
   - Installs yadm using Homebrew
   - Backs up any existing dotfiles
   - Clones the dotfiles repository
   - Runs the bootstrap script

2. **Cleanup previous installation**:
   - Removes yadm via Homebrew if installed
   - Cleans up yadm repository data

3. **Restore from backup**:
   - Lists available backups
   - Allows selecting and restoring from previous backups

You can also run in non-interactive mode with the `--non-interactive` flag:
```bash
./install.sh --non-interactive
```

## Testing the Setup

To test the setup process from scratch (for example, after making changes to the bootstrap process):

### Uninstalling/Resetting YADM

The easiest way to uninstall or reset YADM is to use the cleanup option in the installation script:

```bash
./install.sh  # Then select option 2 (Cleanup previous installation)
```

This will:
1. Remove yadm via Homebrew if installed
2. Clean up yadm repository data

If you prefer to do it manually:

1. **Remove tracked files**:
   ```bash
   yadm list -a | xargs -I{} rm -f "$HOME/{}"
   ```

2. **Remove yadm repository and metadata**:
   ```bash
   rm -rf "$HOME/.local/share/yadm/repo.git"  # Remove the Git repository
   rm -rf "$HOME/.config/yadm"                # Remove yadm config
   rm -rf "$HOME/.local/share/yadm"           # Remove additional yadm data
   ```

3. **Uninstall yadm**:
   ```bash
   brew uninstall yadm
   ```

4. **Start fresh**:
   After cleaning everything, run the installation script again to start fresh:
   ```bash
   ./install.sh
   ```

## Troubleshooting

### Bootstrap Script Not Running

If `yadm bootstrap` isn't running automatically after cloning:

1. Verify that `.config/yadm/bootstrap` exists and is executable:
   ```bash
   ls -l ~/.config/yadm/bootstrap
   ```

2. Make it executable if needed:
   ```bash
   chmod +x ~/.config/yadm/bootstrap
   ```

3. Run it manually:
   ```bash
   yadm bootstrap
   ```

### Finding Auto-Added Content

The `.zshrc` file includes a special section at the end for content that may be auto-added by tools. Periodically check this section and move entries to their appropriate configuration files.

### Multiple GitHub Accounts

This dotfiles repository includes a preconfigured SSH config file (`.ssh/config`) that supports two GitHub accounts:

1. **Primary account**: Uses `~/.ssh/id_ed25519`
   - Used for normal GitHub operations: `git clone git@github.com:username/repo.git`

2. **Secondary account**: Uses `~/.ssh/id_ed25519-2`
   - Used with the `github-2` host alias: `git clone git@github-2:username/repo.git`

The bootstrap script:
- Generates both SSH keys if they don't exist
- Sets appropriate permissions on keys and the config file
- Prompts you to add each key to your GitHub accounts
- Tests connectivity to GitHub for each key

To manually test connectivity:
```bash
# Test primary account
ssh -T git@github.com

# Test secondary account
ssh -T git@github-2
```

When working with repositories from your secondary account, remember to:
```bash
# Clone from secondary account
git clone git@github-2:username/repo.git

# Or change remote on existing repo to use secondary account
git remote set-url origin git@github-2:username/repo.git
```

## Advanced Operations

### Optional: Enabling YADM Encryption

By default, this dotfiles setup doesn't use YADM's encryption feature to simplify the setup process. However, if you have sensitive files you'd like to encrypt:

1. Add file patterns to the encrypt file:
   ```bash
   echo ".ssh/config" >> ~/.config/yadm/encrypt
   echo "path/to/sensitive/file" >> ~/.config/yadm/encrypt
   ```

2. Encrypt the files:
   ```bash
   yadm encrypt
   ```

3. Decrypt on a new machine:
   ```bash
   yadm decrypt
   ```

**Troubleshooting GPG:**  
If you encounter errors like `Inappropriate ioctl for device` when encrypting:

- Set TTY for GPG:
  ```bash
  export GPG_TTY=$(tty)
  echo "UPDATESTARTUPTTY" | gpg-connect-agent > /dev/null 2>&1
  ```

- Install appropriate pinentry programs:
  - For GUI environments: `sudo apt install pinentry-gtk2` (Debian/Ubuntu)
  - For terminal environments: `sudo apt install pinentry-tty` (Debian/Ubuntu)
  - For macOS: `brew install pinentry-mac`

- Configure GPG to use the right pinentry:
  ```bash
  echo "pinentry-program /usr/bin/pinentry-tty" > ~/.gnupg/gpg-agent.conf
  gpgconf --kill gpg-agent
  ```

### Using Alternative Files

For OS-specific configurations:

```bash
# Create a Linux-specific file
yadm add ~/.config/tool/config##os.Linux

# Create a macOS-specific file
yadm add ~/.config/tool/config##os.Darwin
```

---

For more information on working with yadm, refer to the [official yadm documentation](https://yadm.io/docs/overview).
