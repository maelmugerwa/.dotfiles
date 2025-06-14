#!/usr/bin/env bash

# install.sh - Interactive dotfiles installation script
# 
# This script provides an interactive menu to manage dotfiles:
# - Install: Complete setup of dotfiles and development tools
#   * Installs Homebrew package manager (macOS & Linux)
#   * Installs yadm (Yet Another Dotfiles Manager) using Homebrew
#   * Backs up existing dotfiles to prevent conflicts
#   * Clones the dotfiles repository into the appropriate locations
#   * Runs the bootstrap script for additional setup
# - Cleanup: Remove previous installations
#   * Uninstall yadm via Homebrew
#   * Remove yadm repository data and configuration
# - Restore: Restore from previous backups
#   * List and select available backups
#   * Clean up before restoration to prevent conflicts
#   * Restore selected files to their original locations
#
# Usage:
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/maelmugerwa/.dotfiles/main/.config/install.sh)"  # Interactive menu mode (recommended)
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/maelmugerwa/.dotfiles/main/.config/install.sh)" -- --non-interactive  # Skip the menu, perform standard install
#
# Note: The old method of installation (piping curl directly to bash) does not work properly with interactive mode:
#   curl -fsSL ... | bash  # AVOID using this method as it breaks interactive input
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

# Install Homebrew for macOS or Linux
install_homebrew() {
  if ! command -v brew &> /dev/null; then
    log_info "Installing Homebrew..."
    
    # Use the official Homebrew installation script
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to path based on OS and architecture
    if [[ "$OS" == "Darwin" ]]; then
      # macOS - handle different architectures
      if [[ "$(uname -m)" == "arm64" ]]; then
        # M1/M2 Mac
        eval "$(/opt/homebrew/bin/brew shellenv)"
      else
        # Intel Mac
        eval "$(/usr/local/bin/brew shellenv)"
      fi
    else
      # Linux
      if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      elif [[ -d "$HOME/.linuxbrew" ]]; then
        eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
      fi
    fi
    
    log_success "Homebrew installed successfully!"
  else
    log_info "Homebrew is already installed."
  fi
}

# Install yadm using Homebrew
install_yadm() {
  if ! command -v yadm &> /dev/null; then
    log_info "Installing yadm using Homebrew..."
    
    # Ensure Homebrew is available in this shell session
    if [[ "$OS" == "Darwin" ]]; then
      if [[ "$(uname -m)" == "arm64" ]]; then
        # M1/M2 Mac
        eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || true
      else
        # Intel Mac
        eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null || true
      fi
    else
      # Linux
      if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" 2>/dev/null || true
      elif [[ -d "$HOME/.linuxbrew" ]]; then
        eval "$("$HOME/.linuxbrew/bin/brew" shellenv)" 2>/dev/null || true
      fi
    fi
    
    # Install yadm with Homebrew
    brew install yadm
    
    log_success "yadm installed successfully!"
  else
    log_info "yadm is already installed."
  fi
}

# Clean up previous installations
cleanup() {
  log_info "Cleaning up previous installations..."
  
  # Remove all files tracked by yadm if it's installed
  if command -v yadm &> /dev/null; then
    log_info "Removing files tracked by yadm..."
    # First try to get a list of tracked files and remove them
    yadm list -a 2>/dev/null | while read -r file; do
      local full_path="$HOME/$file"
      if [[ -f "$full_path" || -d "$full_path" ]]; then
        log_info "Removing tracked file: $file"
        rm -rf "$full_path"
      fi
    done
    
    log_info "Removing yadm..."
    brew uninstall yadm 2>/dev/null || true
  fi
  
  # Remove yadm repository data
  if [[ -d "$HOME/.local/share/yadm" ]]; then
    log_info "Removing yadm repository data..."
    rm -rf "$HOME/.local/share/yadm" 2>/dev/null || true
    rm -rf "$HOME/.config/yadm" 2>/dev/null || true
  fi
  
  log_success "Cleanup completed!"
}

# Restore from backup
restore_from_backup() {
  # Find backup directories
  backup_dirs=($(find "$HOME" -maxdepth 1 -type d -name "dotfiles_backup_*" | sort -r))
  
  if [[ ${#backup_dirs[@]} -eq 0 ]]; then
    log_error "No backup directories found!"
    return 1
  fi
  
  echo "Available backups:"
  for i in "${!backup_dirs[@]}"; do
    echo "  $((i+1))) ${backup_dirs[$i]} ($(date -r "${backup_dirs[$i]}" "+%Y-%m-%d %H:%M:%S"))"
  done
  
  # Check if the script is running with stdin connected to a terminal
  if [ -t 0 ]; then
    read -p "Select a backup to restore [1-${#backup_dirs[@]}]: " backup_choice
    
    if ! [[ "$backup_choice" =~ ^[0-9]+$ ]] || [ "$backup_choice" -lt 1 ] || [ "$backup_choice" -gt "${#backup_dirs[@]}" ]; then
      log_error "Invalid selection!"
      return 1
    fi
  else
    # If stdin is not a terminal, default to the most recent backup
    log_warn "Interactive input not available (stdin is not a terminal)."
    log_warn "Defaulting to the most recent backup (option 1)."
    backup_choice=1
    sleep 2
  fi
  
  selected_backup="${backup_dirs[$((backup_choice-1))]}"
  
  # Clean up before restoration to prevent conflicts
  log_info "Cleaning up before restoration to prevent conflicts..."
  cleanup
  
  log_info "Restoring from $selected_backup..."
  
  for file in "$selected_backup"/*; do
    fname=$(basename "$file")
    log_info "Restoring $fname to $HOME/$fname"
    cp -r "$file" "$HOME/$fname"
  done
  
  log_success "Restoration completed!"
}

# Interactive menu system
interactive_menu() {
  clear
  echo "========================================"
  echo "     Dotfiles Installation Script       "
  echo "========================================"
  echo ""
  echo "Please select an option:"
  echo ""
  echo "1) Install dotfiles (standard installation)"
  echo "2) Cleanup previous installation"
  echo "3) Restore from backup"
  echo "4) Exit"
  echo ""
  
  # Check if the script is running with stdin connected to a terminal
  # This prevents hanging when the script is piped to bash without process substitution
  if [ -t 0 ]; then
    read -p "Enter your choice [1-4]: " choice
  else
    # If stdin is not a terminal, default to non-interactive installation
    log_warn "Interactive input not available (stdin is not a terminal)."
    log_warn "Defaulting to standard installation (option 1)."
    log_warn "For interactive mode, use: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/maelmugerwa/.dotfiles/main/.config/install.sh)\""
    choice=1
    sleep 2
  fi
  
  case "$choice" in
    1)
      install_dotfiles
      ;;
    2)
      cleanup
      echo ""
      if [ -t 0 ]; then
        read -p "Press Enter to return to the menu or Ctrl+C to exit..."
        interactive_menu
      else
        log_info "Returning to menu automatically (stdin is not a terminal)."
        sleep 2
        interactive_menu
      fi
      ;;
    3)
      restore_from_backup
      echo ""
      if [ -t 0 ]; then
        read -p "Press Enter to return to the menu or Ctrl+C to exit..."
        interactive_menu
      else
        log_info "Returning to menu automatically (stdin is not a terminal)."
        sleep 2
        interactive_menu
      fi
      ;;
    4)
      echo "Exiting..."
      exit 0
      ;;
    *)
      echo "Invalid option. Please try again."
      sleep 1
      interactive_menu
      ;;
  esac
}

# Standard installation process
install_dotfiles() {
  # Install Homebrew
  install_homebrew
  
  # Install yadm using Homebrew
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
  
  # Clone the repository and let YADM handle bootstrap automatically
  log_info "Cloning repository and responding to bootstrap prompt..."
  # Use yes to automatically answer 'y' to bootstrap prompt
  yes | yadm clone "$REPO_URL"
  
  log_success "Dotfiles installed successfully!"
}

# Note: After installation, use the following commands to manage your dotfiles:
# - yadm status                 # Check for changes
# - yadm add [file]             # Track a file
# - yadm commit -m "message"    # Commit changes
# - yadm push                   # Push changes to remote repository
# - yadm pull                   # Get the latest updates

main() {
  # Check if stdin is connected to a terminal
  if ! [ -t 0 ] && [ "$1" != "--non-interactive" ]; then
    # If stdin is not a terminal and not in non-interactive mode,
    # this is likely being run with: curl ... | bash
    echo ""
    log_warn "Interactive input may not work correctly when piping to bash."
    log_warn "For proper interactive mode, use:"
    log_warn "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/maelmugerwa/.dotfiles/main/.config/install.sh)\""
    log_warn ""
    log_warn "Continuing in 3 seconds (Ctrl+C to cancel)..."
    sleep 3
  fi

  # Check if non-interactive mode requested
  if [[ "$1" == "--non-interactive" ]]; then
    install_dotfiles
    return
  fi
  
  # Otherwise show the interactive menu
  interactive_menu
}

# Run the main function
main
