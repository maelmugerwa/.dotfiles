#!/usr/bin/env bash

# install.sh - One-click dotfiles installation script
# 
# This script performs a complete setup of dotfiles and development tools:
# - Installs yadm (Yet Another Dotfiles Manager) if not already present
# - Backs up any existing dotfiles to prevent conflicts
# - Clones the dotfiles repository into the appropriate locations
# - Runs the bootstrap script to set up tools and configurations
#
# Prerequisites:
# - Git (will be installed by bootstrap script if missing)
# - Curl (used to download this script)
# - Sudo privileges (for installing packages)
#
# The dotfiles include configurations for:
# - ZSH (shell setup, prompt, plugins, etc.)
# - Git (aliases, defaults, useful commands)
# - Modern CLI tools (bat, ripgrep, fd, etc.)
# - Development environment preferences

set -e

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Detect operating system
OS="$(uname -s)"
log_info "Detected OS: $OS"

# GitHub repository URL
REPO_URL="https://github.com/maelmugerwa/.dotfiles.git"

# Install yadm if not already installed
install_yadm() {
  if ! command -v yadm &> /dev/null; then
    log_info "Installing yadm..."
    
    if [[ "$OS" == "Darwin" ]]; then
      # macOS
      if ! command -v brew &> /dev/null; then
        log_info "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to path based on architecture
        if [[ "$(uname -m)" == "arm64" ]]; then
          # M1/M2 Mac
          eval "$(/opt/homebrew/bin/brew shellenv)"
        else
          # Intel Mac
          eval "$(/usr/local/bin/brew shellenv)"
        fi
      fi
      
      brew install yadm
    else
      # Linux
      if command -v apt &> /dev/null; then
        # Debian/Ubuntu
        sudo apt update
        sudo apt install -y yadm
      elif command -v dnf &> /dev/null; then
        # Fedora/RHEL
        sudo dnf install -y yadm
      elif command -v pacman &> /dev/null; then
        # Arch
        sudo pacman -S --noconfirm yadm
      elif command -v zypper &> /dev/null; then
        # openSUSE
        sudo zypper install -y yadm
      else
        # Fallback to manual installation
        log_info "Package manager not found. Installing yadm manually..."
        curl -fsSL https://github.com/TheLocehiliosan/yadm/raw/master/yadm -o /tmp/yadm
        chmod a+x /tmp/yadm
        sudo mv /tmp/yadm /usr/local/bin/
      fi
    fi
    
    log_success "yadm installed successfully!"
  else
    log_info "yadm is already installed."
  fi
}

# Clone dotfiles repository and set up environment
clone_dotfiles() {
  log_info "Cloning dotfiles repository..."
  
  # Check if there are any conflicting dotfiles
  if [[ -f "$HOME/.zshrc" || -f "$HOME/.gitconfig" ]]; then
    log_warn "Existing dotfiles detected. They will be backed up."
    
    backup_dir="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    for file in .zshrc .gitconfig .bashrc .vimrc .config/starship.toml; do
      if [[ -f "$HOME/$file" || -d "$HOME/$file" ]]; then
        log_info "Backing up $file to $backup_dir/"
        cp -r "$HOME/$file" "$backup_dir/" 2>/dev/null || true
      fi
    done
  fi
  
  # Clone the repository
  yadm clone "$REPO_URL"
  
  # Run the bootstrap script if available
  if yadm ls-files | grep -q "^yadm/bootstrap$"; then
    log_info "Running bootstrap script..."
    log_info "This will install additional tools and configure your environment"
    log_info "The bootstrap process includes:"
    log_info " - Installing Homebrew (package manager)"
    log_info " - Setting up essential CLI tools"
    log_info " - Configuring ZSH with useful plugins"
    log_info " - Creating a basic development environment"
    yadm bootstrap
  else
    log_warn "Bootstrap script not found. You may need to run it manually."
  fi
  
  log_success "Dotfiles installed successfully!"
}

# Note: After installation, use the following commands to manage your dotfiles:
# - yadm status                 # Check for changes
# - yadm add [file]             # Track a file
# - yadm commit -m "message"    # Commit changes
# - yadm push                   # Push changes to remote repository
# - yadm pull                   # Get the latest updates

main() {
  echo "========================================"
  echo "     Dotfiles Installation Script       "
  echo "========================================"
  echo ""
  
  # Install yadm
  install_yadm
  
  # Clone dotfiles
  clone_dotfiles
  
  echo ""
  echo "========================================"
  log_success "Installation complete!"
  log_info "Please restart your shell or open a new terminal window for all changes to take effect."
  log_info "Use 'source ~/.zshrc' to reload without restarting."
  echo "========================================"
}

# Run the main function
main
