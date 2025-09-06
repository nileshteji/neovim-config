#!/bin/bash

# Neovim Configuration Installation Script
# This script will install and set up the custom Neovim configuration

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"

print_info "Starting Neovim configuration installation..."
print_info "Configuration source: $SCRIPT_DIR"
print_info "Target directory: $NVIM_CONFIG_DIR"

# Check if Neovim is installed
if ! command -v nvim &> /dev/null; then
    print_error "Neovim is not installed. Please install Neovim first."
    print_info "On macOS: brew install neovim"
    print_info "On Ubuntu: sudo apt install neovim"
    exit 1
fi

print_success "Neovim is installed: $(nvim --version | head -n1)"

# Create .config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Backup existing configuration if it exists
if [ -d "$NVIM_CONFIG_DIR" ]; then
    print_warning "Existing Neovim configuration found"
    print_info "Creating backup at: $BACKUP_DIR"
    cp -r "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
    print_success "Backup created successfully"
    
    # Remove existing configuration
    rm -rf "$NVIM_CONFIG_DIR"
    print_info "Removed existing configuration"
fi

# Copy the new configuration
print_info "Installing new Neovim configuration..."
cp -r "$SCRIPT_DIR" "$NVIM_CONFIG_DIR"

# Remove the install script from the config directory
rm -f "$NVIM_CONFIG_DIR/install.sh"

print_success "Configuration files copied successfully"

# Create undo directory
UNDO_DIR="$HOME/.vim/undodir"
if [ ! -d "$UNDO_DIR" ]; then
    print_info "Creating undo directory: $UNDO_DIR"
    mkdir -p "$UNDO_DIR"
    print_success "Undo directory created"
fi

# Install Packer if not already installed
PACKER_DIR="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
if [ ! -d "$PACKER_DIR" ]; then
    print_info "Installing Packer plugin manager..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_DIR"
    print_success "Packer installed successfully"
else
    print_info "Packer is already installed"
fi

# Install plugins using Packer
print_info "Installing Neovim plugins..."
print_warning "This may take a few minutes..."

# Run PackerSync in headless mode with better error handling
if nvim --headless -c 'lua require("nilesh.packer")' -c 'autocmd User PackerComplete quitall' -c 'PackerSync' 2>/dev/null; then
    print_success "Plugins installed successfully"
else
    print_warning "Initial plugin sync encountered issues. This is normal for first-time setup."
    print_info "Plugins will be installed when you first open Neovim"
fi

# Final setup steps
print_info "Performing final setup..."

# Install Treesitter parsers (this will happen automatically when you first use Neovim)
print_info "Note: Treesitter parsers will be installed automatically when you first open files"

print_success "Installation completed successfully!"
print_info ""
print_info "Next steps:"
print_info "1. Open Neovim with: nvim"
print_info "2. If you encounter any plugin issues, run: :PackerSync"
print_info "3. For LSP setup, run: :Mason to install language servers"
print_info ""
print_info "Your previous configuration has been backed up to: $BACKUP_DIR"
print_info "Key bindings:"
print_info "  - Leader key: Space"
print_info "  - File finder: <leader>pf"
print_info "  - Git files: <C-p>"
print_info "  - Live grep: <leader>ps"
print_info "  - File explorer: <leader>pv"
print_info ""
print_success "Enjoy your new Neovim setup!"
