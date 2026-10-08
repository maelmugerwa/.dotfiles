#!/usr/bin/env bash

# install.sh - interactive menu to install, clean up or restore these dotfiles.
#
# Install: installs Homebrew, installs yadm, backs up existing dotfiles,
# clones the repository, then runs the bootstrap script.
# Cleanup: uninstalls yadm and removes its repository data and config.
# Restore: lists backups, cleans up to avoid conflicts, restores your choice.
#
# Usage:
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/maelmugerwa/.dotfiles/main/.config/install.sh)"  # Interactive menu mode (recommended)
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/maelmugerwa/.dotfiles/main/.config/install.sh)" -- --non-interactive  # Skip the menu, perform standard install
#
# Do NOT pipe curl straight to bash. `curl -fsSL ... | bash` leaves stdin at
# EOF, so every interactive prompt reads nothing.
#
# Prerequisites:
# - Git (bootstrap installs it if missing)
# - Curl (downloads this script)
# - Sudo rights (package installs need them)
#
# The dotfiles configure zsh, git, modern CLI tools (bat, ripgrep, fd) and
# language runtimes through mise (node, python, go).

set -e

# Output colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

OS="$(uname -s)"
log_info "Detected OS: $OS"

REPO_URL="https://github.com/maelmugerwa/.dotfiles.git"

install_homebrew() {
  if ! command -v brew &> /dev/null; then
    log_info "Installing Homebrew..."

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this OS and architecture
    if [[ "$OS" == "Darwin" ]]; then
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

install_yadm() {
  if ! command -v yadm &> /dev/null; then
    log_info "Installing yadm using Homebrew..."
    
    # The fresh Homebrew install is not on PATH yet in this shell.
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
    
    brew install yadm
    
    log_success "yadm installed successfully!"
  else
    log_info "yadm is already installed."
  fi
}

cleanup() {
  log_info "Cleaning up previous installations..."

  if command -v yadm &> /dev/null; then
    log_info "Removing files tracked by yadm..."
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
  
  if [[ -d "$HOME/.local/share/yadm" ]]; then
    log_info "Removing yadm repository data..."
    rm -rf "$HOME/.local/share/yadm" 2>/dev/null || true
    rm -rf "$HOME/.config/yadm" 2>/dev/null || true
  fi
  
  log_success "Cleanup completed!"
}

restore_from_backup() {
  backup_dirs=($(find "$HOME" -maxdepth 1 -type d -name "dotfiles_backup_*" | sort -r))
  
  if [[ ${#backup_dirs[@]} -eq 0 ]]; then
    log_error "No backup directories found!"
    return 1
  fi
  
  echo "Available backups:"
  for i in "${!backup_dirs[@]}"; do
    # Print the directory name, which already carries the timestamp.
    # Do NOT use `date -r`: GNU reads a reference file, BSD reads epoch
    # seconds, so it breaks on macOS.
    echo "  $((i+1))) ${backup_dirs[$i]}"
  done
  
  if [ -t 0 ]; then
    read -p "Select a backup to restore [1-${#backup_dirs[@]}]: " backup_choice
    
    if ! [[ "$backup_choice" =~ ^[0-9]+$ ]] || [ "$backup_choice" -lt 1 ] || [ "$backup_choice" -gt "${#backup_dirs[@]}" ]; then
      log_error "Invalid selection!"
      return 1
    fi
  else
    log_warn "Interactive input not available (stdin is not a terminal)."
    log_warn "Defaulting to the most recent backup (option 1)."
    backup_choice=1
    sleep 2
  fi
  
  selected_backup="${backup_dirs[$((backup_choice-1))]}"
  
  log_info "Cleaning up before restoration to prevent conflicts..."
  cleanup
  
  log_info "Restoring from $selected_backup..."
  
  # Copy the tree as-is so nested paths land back under .config, not in $HOME.
  log_info "Restoring files to $HOME"
  cp -a "$selected_backup/." "$HOME/"
  
  log_success "Restoration completed!"
}

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
  
  # Guard the prompt: a piped script has no terminal and would hang here.
  if [ -t 0 ]; then
    read -p "Enter your choice [1-4]: " choice
  else
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

install_dotfiles() {
  install_homebrew
  install_yadm
  clone_dotfiles


  echo ""
  echo "========================================"
  log_success "Installation complete!"
  log_info "Please restart your shell or open a new terminal window for all changes to take effect."
  log_info "Use 'source ~/.zshrc' to reload without restarting."
  echo "========================================"
}

clone_dotfiles() {
  log_info "Cloning dotfiles repository..."

  if [[ -f "$HOME/.zshrc" || -f "$HOME/.zshenv" || -f "$HOME/.gitconfig" \
     || -d "$HOME/.config/git" || -d "$HOME/.config/zsh" ]]; then
    log_warn "Existing dotfiles detected. They will be backed up."

    backup_dir="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"

    # yadm clone leaves a pre-existing file alone, so back up every path this
    # repo tracks. Keep the relative path: a flat copy restores .config/git
    # to ~/git. axe and mwinit collide on .ssh/config and .config/mise.
    for file in .zshrc .zshenv .gitconfig .bashrc .vimrc .ssh/config \
                .config/starship.toml .config/git .config/zsh \
                .config/homebrew .config/mise; do
      if [[ -f "$HOME/$file" || -d "$HOME/$file" ]]; then
        log_info "Backing up $file to $backup_dir/$file"
        mkdir -p "$backup_dir/$(dirname "$file")"
        cp -r "$HOME/$file" "$backup_dir/$file" 2>/dev/null || true
      fi
    done
  fi
  
  # --bootstrap removes the "run bootstrap?" question. A bare `yadm clone`
  # hangs an unattended install on a tty. Under `curl | bash` the prompt
  # reads EOF and yadm SKIPS bootstrap, so the script claims success with no
  # packages, no runtimes and no SSH keys.
  log_info "Cloning repository and running bootstrap..."
  yadm clone --bootstrap "$REPO_URL"
  
  log_success "Dotfiles installed successfully!"
}

# Manage your dotfiles after installation with these commands:
# - yadm status                 # Check for changes
# - yadm add [file]             # Track a file
# - yadm commit -m "message"    # Commit changes
# - yadm push                   # Push changes to remote repository
# - yadm pull                   # Get the latest updates

main() {
  # No terminal and no --non-interactive flag means someone ran `curl | bash`.
  if ! [ -t 0 ] && [ "$1" != "--non-interactive" ]; then
    echo ""
    log_warn "Interactive input may not work correctly when piping to bash."
    log_warn "For proper interactive mode, use:"
    log_warn "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/maelmugerwa/.dotfiles/main/.config/install.sh)\""
    log_warn ""
    log_warn "Continuing in 3 seconds (Ctrl+C to cancel)..."
    sleep 3
  fi

  if [[ "$1" == "--non-interactive" ]]; then
    install_dotfiles
    return
  fi

  interactive_menu
}

main
