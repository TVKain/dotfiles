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

# Installation tracking
INSTALL_MARKER="$HOME/.dotfiles_installed"
INSTALL_VERSION="1.0"

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

# Function to check if this is an upgrade
check_installation_type() {
    if [ -f "$INSTALL_MARKER" ]; then
        INSTALLED_VERSION=$(cat "$INSTALL_MARKER" | grep "version" | cut -d'=' -f2)
        INSTALLED_DATE=$(cat "$INSTALL_MARKER" | grep "date" | cut -d'=' -f2)
        print_info "Previous installation detected (version $INSTALLED_VERSION on $INSTALLED_DATE)"
        return 0  # This is an upgrade
    else
        return 1  # This is a fresh install
    fi
}

# Function to write installation marker
write_installation_marker() {
    cat > "$INSTALL_MARKER" <<EOF
version=$INSTALL_VERSION
date=$(date +%Y-%m-%d_%H:%M:%S)
dotfiles_dir=$(pwd)
EOF
    print_success "Installation marker created"
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
    if check_installation_type; then
        # This is an upgrade
        echo "This is an UPGRADE installation."
        echo "The installer will:"
        echo "  1. Backup existing configurations"
        echo "  2. Remove existing configurations"
        echo "  3. Install updated dotfiles"
        echo ""
        read -p "Do you want to continue with the upgrade? (y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Upgrade cancelled by user"
            exit 0
        fi
    elif check_existing_configs; then
        # This is a fresh install with existing configs
        echo "This is a FRESH installation with existing configurations."
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
        # This is a fresh install with no existing configs
        print_info "Fresh installation with no existing configurations. Proceeding..."
    fi
}

# Function to backup existing configs
backup_configs() {
    print_info "Backing up existing configurations..."
    
    BACKUP_DIR="/tmp/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$BACKUP_DIR/" && print_info "Backed up .zshrc"
    [ -f "$HOME/.tmux.conf" ] && cp "$HOME/.tmux.conf" "$BACKUP_DIR/" && print_info "Backed up .tmux.conf"
    [ -f "$HOME/.vimrc" ] && cp "$HOME/.vimrc" "$BACKUP_DIR/" && print_info "Backed up .vimrc"
    [ -d "$HOME/.vim" ] && cp -r "$HOME/.vim" "$BACKUP_DIR/" && print_info "Backed up .vim"
    [ -f "$HOME/.config/starship.toml" ] && cp "$HOME/.config/starship.toml" "$BACKUP_DIR/" && print_info "Backed up starship.toml"
    
    print_success "Backups created successfully"
    print_info "Backup location: $BACKUP_DIR"
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
    
    # Install fzf and ripgrep (required for vim plugins)
    if ! command -v fzf &> /dev/null; then
        print_info "Installing fzf..."
        sudo apt install -y fzf
        print_success "fzf installed"
    else
        print_success "fzf already installed"
    fi
    
    if ! command -v rg &> /dev/null; then
        print_info "Installing ripgrep..."
        sudo apt install -y ripgrep
        print_success "ripgrep installed"
    else
        print_success "ripgrep already installed"
    fi
    
    # Install zoxide (smart cd command)
    if ! command -v zoxide &> /dev/null; then
        print_info "Installing zoxide..."
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
        print_success "zoxide installed"
    else
        print_success "zoxide already installed"
    fi
    
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
    
    # Install vim-plug if not already installed
    if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
        print_info "Installing vim-plug..."
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        print_success "vim-plug installed"
    else
        print_success "vim-plug already installed"
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

# Function to install vim plugins
install_vim_plugins() {
    print_info "Installing vim plugins..."
    if [ -f "$HOME/.vim/autoload/plug.vim" ]; then
        vim +PlugInstall +qall
        print_success "Vim plugins installed"
    else
        print_warning "vim-plug not found, skipping vim plugin installation"
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
    install_vim_plugins
    write_installation_marker
    
    echo ""
    echo "=========================================="
    print_success "Installation completed!"
    echo "=========================================="
    echo ""
    print_info "Backup location: $BACKUP_DIR"
    print_info "Installation version: $INSTALL_VERSION"
    print_info "Please log out and log back in for all changes to take effect."
    print_info "Or run: source ~/.zshrc"
    echo ""
}

# Run main function
main