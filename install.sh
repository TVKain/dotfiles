#!/bin/bash

# Dotfiles Installer
# Supports: Ubuntu 24.04+

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Global variable for backup directory
BACKUP_DIR=""

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${NC}→ $1${NC}"
}

# Function to detect OS
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VERSION=$VERSION_ID
    else
        print_error "Cannot detect OS"
        exit 1
    fi
}

# Function to check if OS is supported
check_os_support() {
    detect_os
    
    if [ "$OS" != "ubuntu" ]; then
        print_error "Unsupported OS: $OS. Only Ubuntu is supported."
        exit 1
    fi
    
    # Check if version is 24.04 or higher
    IFS='.' read -r major minor <<< "$VERSION"
    if [ "$major" -lt 24 ] || ([ "$major" -eq 24 ] && [ "$minor" -lt 04 ]); then
        print_error "Unsupported Ubuntu version: $VERSION. Only Ubuntu 24.04+ is supported."
        exit 1
    fi
    
    print_success "Detected Ubuntu $VERSION"
}

# Function to check for existing configs
check_existing_configs() {
    EXISTING_CONFIGS=()
    
    [ -f "$HOME/.zshrc" ] && EXISTING_CONFIGS+=(".zshrc")
    [ -f "$HOME/.tmux.conf" ] && EXISTING_CONFIGS+=(".tmux.conf")
    [ -f "$HOME/.vimrc" ] && EXISTING_CONFIGS+=(".vimrc")
    [ -d "$HOME/.vim" ] && EXISTING_CONFIGS+=(".vim")
    [ -f "$HOME/.config/starship.toml" ] && EXISTING_CONFIGS+=("starship.toml")
    
    if [ ${#EXISTING_CONFIGS[@]} -gt 0 ]; then
        echo ""
        print_warning "Found existing configuration files:"
        for config in "${EXISTING_CONFIGS[@]}"; do
            echo "  - $config"
        done
        echo ""
        return 0
    else
        return 1
    fi
}

# Function to prompt user for confirmation
prompt_user() {
    if check_existing_configs; then
        echo "The installer will:"
        echo "  1. Backup existing configurations"
        echo "  2. Remove existing configurations"
        echo "  3. Install new dotfiles"
        echo ""
        read -p "Do you want to continue? (y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Installation cancelled by user"
            exit 0
        fi
    else
        print_info "No existing configurations found. Proceeding with installation."
    fi
}

# Function to backup existing configs
backup_configs() {
    print_info "Backing up existing configurations..."
    
    BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$BACKUP_DIR/" && print_info "Backed up .zshrc"
    [ -f "$HOME/.tmux.conf" ] && cp "$HOME/.tmux.conf" "$BACKUP_DIR/" && print_info "Backed up .tmux.conf"
    [ -f "$HOME/.vimrc" ] && cp "$HOME/.vimrc" "$BACKUP_DIR/" && print_info "Backed up .vimrc"
    [ -d "$HOME/.vim" ] && cp -r "$HOME/.vim" "$BACKUP_DIR/" && print_info "Backed up .vim"
    [ -f "$HOME/.config/starship.toml" ] && cp "$HOME/.config/starship.toml" "$BACKUP_DIR/" && print_info "Backed up starship.toml"
    
    print_success "Backups created in $BACKUP_DIR"
}

# Function to remove existing configs
remove_existing_configs() {
    print_info "Removing existing configurations..."
    
    [ -f "$HOME/.zshrc" ] && rm "$HOME/.zshrc" && print_info "Removed .zshrc"
    [ -f "$HOME/.tmux.conf" ] && rm "$HOME/.tmux.conf" && print_info "Removed .tmux.conf"
    [ -f "$HOME/.vimrc" ] && rm "$HOME/.vimrc" && print_info "Removed .vimrc"
    [ -d "$HOME/.vim" ] && rm -rf "$HOME/.vim" && print_info "Removed .vim"
    [ -f "$HOME/.config/starship.toml" ] && rm "$HOME/.config/starship.toml" && print_info "Removed starship.toml"
    
    print_success "Existing configurations removed"
}

# Function to install dependencies
install_dependencies() {
    print_info "Installing dependencies..."
    
    sudo apt update
    
    # Install basic tools
    sudo apt install -y git curl zsh vim tmux
    
    # Install starship if not already installed
    if ! command -v starship &> /dev/null; then
        print_info "Installing starship..."
        curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir ~/.local/bin
        print_success "Starship installed"
    else
        print_success "Starship already installed"
    fi
    
    # Install TPM (tmux plugin manager) if not already installed
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        print_info "Installing TPM (tmux plugin manager)..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        print_success "TPM installed"
    else
        print_success "TPM already installed"
    fi
}

# Function to install dotfiles
install_dotfiles() {
    print_info "Installing dotfiles..."
    
    # Get the directory where this script is located
    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Create config directory if it doesn't exist
    mkdir -p "$HOME/.config"
    
    # Copy zsh config
    cp "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
    print_success "Installed .zshrc"
    
    # Copy tmux config
    cp "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
    print_success "Installed .tmux.conf"
    
    # Copy vim config
    cp "$DOTFILES_DIR/vimrc" "$HOME/.vimrc"
    print_success "Installed .vimrc"
    
    # Copy vim directory
    if [ -d "$DOTFILES_DIR/vim" ]; then
        cp -r "$DOTFILES_DIR/vim" "$HOME/.vim"
        print_success "Installed .vim directory"
    fi
    
    # Copy starship config
    mkdir -p "$HOME/.config"
    cp "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml"
    print_success "Installed starship.toml"
}

# Function to set zsh as default shell
set_default_shell() {
    if [ "$SHELL" != "$(which zsh)" ]; then
        print_info "Setting zsh as default shell..."
        chsh -s "$(which zsh)"
        print_success "Default shell changed to zsh"
    else
        print_success "zsh is already the default shell"
    fi
}

# Function to install tmux plugins
install_tmux_plugins() {
    print_info "Installing tmux plugins..."
    if [ -d "$HOME/.tmux/plugins/tpm" ]; then
        ~/.tmux/plugins/tpm/bin/install_plugins
        print_success "Tmux plugins installed"
    else
        print_warning "TPM not found, skipping tmux plugin installation"
    fi
}

# Main installation process
main() {
    echo "=========================================="
    echo "       Dotfiles Installer"
    echo "=========================================="
    echo ""
    
    check_os_support
    prompt_user
    backup_configs
    remove_existing_configs
    install_dependencies
    install_dotfiles
    set_default_shell
    install_tmux_plugins
    
    echo ""
    echo "=========================================="
    print_success "Installation completed!"
    echo "=========================================="
    echo ""
    print_info "Backups saved to: $BACKUP_DIR"
    print_info "Please log out and log back in for all changes to take effect."
    print_info "Or run: source ~/.zshrc"
    echo ""
}

# Run main function
main