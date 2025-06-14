#!/usr/bin/env bash

# setup-repo.sh - Helper script to set up a GitHub repository for dotfiles
# This script helps configure a remote GitHub repository for your dotfiles

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

setup_repo() {
  # Check if Git is installed
  if ! command -v git &> /dev/null; then
    log_error "Git is not installed. Please install Git first."
    exit 1
  fi
  
  # Check if yadm is installed
  if ! command -v yadm &> /dev/null; then
    log_error "yadm is not installed. Please install yadm first."
    exit 1
  fi
  
  # Get GitHub username and repository name
  read -p "Enter your GitHub username: " github_username
  read -p "Enter repository name (default: dotfiles): " repo_name
  repo_name=${repo_name:-dotfiles}
  
  # Full repository URL
  repo_url="https://github.com/$github_username/$repo_name.git"
  
  # Confirm with user
  echo ""
  echo "Repository URL will be: $repo_url"
  read -p "Is this correct? (y/N): " confirm
  
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    log_warn "Aborted by user."
    exit 0
  fi
  
  # Check if gh CLI is installed for repository creation
  create_repo=false
  if command -v gh &> /dev/null; then
    read -p "Would you like to create the repository on GitHub now? (y/N): " create_confirm
    if [[ "$create_confirm" =~ ^[Yy]$ ]]; then
      create_repo=true
    fi
  else
    log_info "GitHub CLI (gh) not found. You'll need to create the repository manually."
    log_info "Visit: https://github.com/new"
  fi
  
  # Create repository if requested
  if [[ "$create_repo" == true ]]; then
    log_info "Creating GitHub repository: $repo_name"
    
    # Check if user is logged in
    if ! gh auth status &> /dev/null; then
      log_info "Please log in to GitHub:"
      gh auth login
    fi
    
    # Create private repository
    read -p "Make repository private? (Y/n): " private_confirm
    private_flag="--private"
    if [[ "$private_confirm" =~ ^[Nn]$ ]]; then
      private_flag="--public"
    fi
    
    gh repo create "$repo_name" $private_flag --description "My dotfiles managed with yadm" --confirm || {
      log_error "Failed to create repository. You may need to create it manually."
      log_info "Visit: https://github.com/new"
    }
  fi
  
  # Configure yadm remote
  log_info "Setting up yadm remote..."
  yadm remote add origin "$repo_url"
  
  # Set up main branch
  log_info "Setting up main branch..."
  yadm checkout -b main
  
  # Initial commit if needed
  if ! yadm rev-parse --verify HEAD &> /dev/null; then
    log_info "Creating initial commit..."
    yadm add -A
    yadm commit -m "Initial commit"
  fi
  
  # Push to GitHub
  log_info "Pushing to GitHub..."
  yadm push --set-upstream origin main
  
  log_success "Repository setup complete!"
  log_info "Your dotfiles are now tracked at: $repo_url"
}

# Main execution
echo "========================================"
echo "   Dotfiles GitHub Repository Setup     "
echo "========================================"
echo ""

# Run setup
setup_repo
