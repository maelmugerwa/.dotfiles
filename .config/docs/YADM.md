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

The initial setup is handled by `install.sh`, which:

1. Installs yadm if not present
2. Backs up any existing dotfiles
3. Clones the dotfiles repository
4. Runs the bootstrap script

## Testing the Setup

To test the setup process from scratch (for example, after making changes to the bootstrap process):

### Uninstalling/Resetting YADM

1. **Remove tracked files**:
   ```bash
   yadm list -a | xargs -I{} rm -f "$HOME/{}"
   ```

2. **Remove yadm repository and metadata**:
   ```bash
   rm -rf "$HOME/.local/share/yadm/repo.git"  # Remove the Git repository
   rm -rf "$HOME/.config/yadm"                # Remove yadm config
   ```

3. **Clean up any remaining files**:
   ```bash
   # Check for broken symlinks
   find ~/ -maxdepth 1 -type l -exec test ! -e {} \; -print
   ```

4. **Uninstall yadm (optional)**:
   ```bash
   # For Homebrew
   brew uninstall yadm
   
   # For apt-based systems
   sudo apt remove yadm
   
   # For dnf-based systems
   sudo dnf remove yadm
   ```

5. **Start fresh**:
   After cleaning everything, reinstall yadm and re-run the installation script.

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

## Advanced Operations

### Encrypting Sensitive Files

1. Add patterns to the encrypt file:
   ```bash
   echo ".ssh/config" >> ~/.config/yadm/encrypt
   ```

2. Encrypt the files:
   ```bash
   yadm encrypt
   ```

3. Decrypt on a new machine:
   ```bash
   yadm decrypt
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
