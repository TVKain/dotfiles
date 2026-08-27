# Dotfiles

Personal configuration files for Ubuntu 24.04+

## Repository

https://github.com/TVKain/dotfiles

## Contents

- **zsh**: Zsh configuration with starship prompt
- **tmux**: Tmux configuration with plugins and catppuccin theme
- **vim**: Vim configuration with plugins
- **starship**: Starship prompt configuration

## Installation

Clone the repository and run the installer:

```bash
git clone https://github.com/TVKain/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Requirements

- Ubuntu 24.04 or higher
- sudo privileges

## What gets installed

- Zsh with starship prompt
- Tmux with TPM plugin manager
- Vim with configuration
- Starship prompt
- Tmux plugins (via TPM)
- Vim plugins (via vim-plug)
- fzf (fuzzy finder)
- ripgrep (fast search tool)
- zoxide (smart cd command)

## Manual Setup

After installation, you may need to:

1. **Tmux plugins**: Press `Ctrl+B` then `Shift+I` to install tmux plugins (if not auto-installed)
2. **Vim plugins**: The installer automatically runs `:PlugInstall`, but you can manually run it in vim if needed

## Configuration Files

- `zshrc` → `~/.zshrc`
- `tmux.conf` → `~/.tmux.conf`
- `vimrc` → `~/.vimrc`
- `vim/` → `~/.vim/`
- `config/starship.toml` → `~/.config/starship.toml`

## Backup

The installer automatically backs up existing configurations to:
`~/dotfiles_backup_YYYYMMDD_HHMMSS/`

## Installation Tracking

The installer tracks installations using a marker file (`~/.dotfiles_installed`) that includes:
- Installation version
- Installation date
- Dotfiles directory path

This allows the installer to detect:
- **Fresh installations** (no previous installation)
- **Upgrades** (previous installation detected)

When upgrading, the installer will:
1. Detect the previous installation version and date
2. Prompt for confirmation
3. Backup existing configurations
4. Remove old configurations
5. Install updated dotfiles

## Features

### Zsh
- Starship prompt (minimal and fast)
- Custom aliases
- History configuration
- High-precision time command
- zoxide integration (use `z` instead of `cd` for smart directory navigation)

### Tmux
- Mouse support
- Catppuccin theme
- Automatic window renumbering
- Plugin support via TPM

### Vim
- Plugin management via vim-plug
- Custom configuration
- Syntax highlighting and more

### Starship
- Minimal prompt
- Git branch display
- Performance optimized