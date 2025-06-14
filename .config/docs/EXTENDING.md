# Extending Your Dotfiles

This guide explains how to extend and customize your dotfiles setup for different needs. Whether you want to add new shell commands, create custom scripts, or manage additional configuration files, this document will walk you through the process.

## Table of Contents
- [Modular ZSH Configuration](#modular-zsh-configuration)
- [Adding Custom ZSH Commands](#adding-custom-zsh-commands)
- [Creating and Adding Scripts](#creating-and-adding-scripts)
- [Adding New Dotfiles](#adding-new-dotfiles)
- [OS-Specific Configurations](#os-specific-configurations)
- [Managing Sensitive Information](#managing-sensitive-information)
- [Adding Homebrew Packages](#adding-homebrew-packages)

## Modular ZSH Configuration

The ZSH configuration is split into modular files for better organization:

```
.config/zsh/
├── aliases.zsh     # Command aliases and shortcuts
├── completion.zsh  # Completion system configuration
├── core.zsh        # Core ZSH settings and options
├── paths.zsh       # PATH and environment variables
├── plugins.zsh     # Plugin loading mechanism
├── prompt.zsh      # Prompt configuration
└── tools.zsh       # External tool integrations
```

Each file serves a specific purpose and can be modified independently:

- **core.zsh**: Fundamental ZSH settings (history, options, keybindings)
- **completion.zsh**: Tab completion system
- **prompt.zsh**: Shell prompt configuration (starship/spaceship)
- **plugins.zsh**: ZSH plugin loading logic
- **aliases.zsh**: Command shortcuts and aliases
- **tools.zsh**: External tool integrations (zoxide, direnv, etc.)
- **paths.zsh**: PATH and environment variable management

### Modifying Existing Configuration

To modify an existing component, edit the appropriate file:

```bash
# Modify aliases
yadm edit ~/.config/zsh/aliases.zsh

# Change prompt configuration
yadm edit ~/.config/zsh/prompt.zsh
```

No need to edit `.zshrc` directly - it simply loads these modular files.

## Adding Custom ZSH Commands

There are several ways to add new commands, aliases, or functions to your shell environment:

### 1. Adding to Existing Module Files

If your addition fits into an existing category, add it to the appropriate file:

```bash
# Add new aliases
echo 'alias myalias="command-to-run"' >> ~/.config/zsh/aliases.zsh

# Add new tool integration
yadm edit ~/.config/zsh/tools.zsh
```

For a complete reference of existing aliases, see [ALIASES.md](ALIASES.md).

### 2. Creating a Custom ZSH File

For new functionality that doesn't fit existing categories, create a new `.zsh` file:

```bash
# Create a new configuration file
yadm edit ~/.config/zsh/mycustom.zsh
```

Content structure:

```bash
# mycustom.zsh - Brief description of purpose
# Detailed explanation of what this file does

# Your custom configuration here
alias custom-command="command-to-run"

custom-function() {
  echo "This is my custom function"
  # Your function logic here
}

# Set environment variables
export MY_VARIABLE="my-value"
```

The main `.zshrc` automatically loads all `.zsh` files from the `.config/zsh/` directory.

### 3. Using .zshrc.local for Machine-Specific Settings

For settings specific to a single machine, use `.zshrc.local`:

```bash
# Add to ~/.zshrc.local
alias local-alias='command-that-only-works-on-this-machine'
export LOCAL_VARIABLE="local-value"
```

This file is loaded by `.zshrc` but not tracked by yadm.

## Creating and Adding Scripts

For more complex functionality, create standalone executable scripts:

### 1. Creating a Script in ~/.local/bin

```bash
# Create the script file
touch ~/.local/bin/my-script
chmod +x ~/.local/bin/my-script
```

Edit your script with a proper shebang line and content:

```bash
#!/usr/bin/env bash

# Script description
# Usage: my-script [arguments]

# Your script code here
echo "Hello from my custom script!"
```

Since `~/.local/bin` is already added to your PATH in the dotfiles setup, your script will be immediately available to run.

### 2. Script Organization

Consider organizing scripts by category:

```
~/.local/bin/                   # Main directory for all scripts
├── dev/                        # Development-related scripts
│   ├── git-helpers/            # Git helper scripts
│   └── docker-helpers/         # Docker helper scripts
├── system/                     # System maintenance scripts
└── utils/                      # General utility scripts
```

Then add these subdirectories to your PATH in a `.zsh` file:

```bash
# ~/.config/zsh/script-paths.zsh
export PATH="$HOME/.local/bin/dev:$PATH"
export PATH="$HOME/.local/bin/system:$PATH"
export PATH="$HOME/.local/bin/utils:$PATH"
```

### 3. Adding a Script to YADM

Once you're satisfied with your script, add it to yadm:

```bash
yadm add ~/.local/bin/my-script
yadm commit -m "Add my-script utility"
yadm push
```

## Adding New Dotfiles

As you use more tools, you'll want to track their configuration files with yadm:

### 1. Adding a New Configuration File

```bash
# Assuming you've created a new config file
yadm add ~/.config/mynewapp/config.yaml
yadm commit -m "Add configuration for mynewapp"
yadm push
```

### 2. Adding a Directory of Configuration Files

```bash
# Add all files in a directory
yadm add ~/.config/mynewapp/
yadm commit -m "Add complete mynewapp configuration"
yadm push
```

## OS-Specific Configurations

yadm supports alternative files for different operating systems:

### 1. Creating OS-Specific Files

Create files with a special suffix to activate them only on specific operating systems:

```bash
# For Linux-specific configuration
touch ~/.config/app/settings##os.Linux

# For macOS-specific configuration
touch ~/.config/app/settings##os.Darwin

# For a specific hostname
touch ~/.config/app/settings##hostname.work-laptop
```

When yadm clones your repository on a system, it will use the appropriate version based on the OS or hostname.

### 2. Example: OS-Specific ZSH Configuration

```bash
# ~/.zshrc.local##os.Linux
# Linux-specific settings
alias ls='ls --color=auto'
export LINUX_VAR="linux-value"

# ~/.zshrc.local##os.Darwin
# macOS-specific settings
alias ls='ls -G'
export MACOS_VAR="macos-value"
```

## Managing Sensitive Information

Sensitive files can be encrypted with yadm:

### 1. Adding Files to the Encrypt List

Edit the encrypt configuration file:

```bash
echo ".ssh/special_config" >> ~/.config/yadm/encrypt
```

### 2. Encrypting Files

```bash
yadm encrypt
```

### 3. Decrypting Files

After cloning on a new machine:

```bash
yadm decrypt
```

## Adding Homebrew Packages

To add new packages to install on all your machines:

### 1. Edit the Brewfile

Edit `~/.config/homebrew/Brewfile`:

```ruby
# Add a new package
brew "package-name"      # Add a comment describing what the package does

# Add a cask (macOS application)
cask "application-name"  # Add a description of the application
```

### 2. Install the New Packages

```bash
brew bundle --global
```

### 3. Commit Your Changes

```bash
yadm add ~/.config/homebrew/Brewfile
yadm commit -m "Add new package to Brewfile"
yadm push
```

---

By following these guidelines, you can extend your dotfiles configuration in an organized and maintainable way. Remember to commit changes regularly and push to your remote repository to keep all your systems in sync.
