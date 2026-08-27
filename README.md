# Dotfiles

Personal configuration files for Ubuntu 24.04+

## Contents

- **zsh**: Zsh configuration with starship prompt
- **tmux**: Tmux configuration with plugins and catppuccin theme
- **vim**: Vim configuration with plugins
- **starship**: Starship prompt configuration

## Installation

Run the installer script:

```bash
cd dotfiles
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

## Manual Setup

After installation, you may need to:

1. **Tmux plugins**: Press `Ctrl+B` then `Shift+I` to install tmux plugins
2. **Vim plugins**: Open vim and run `:PlugInstall`

## Configuration Files

- `zshrc` → `~/.zshrc`
- `tmux.conf` → `~/.tmux.conf`
- `vimrc` → `~/.vimrc`
- `vim/` → `~/.vim/`
- `config/starship.toml` → `~/.config/starship.toml`

## Backup

The installer automatically backs up existing configurations to:
`~/dotfiles_backup_YYYYMMDD_HHMMSS/`

## Features

### Zsh
- Starship prompt (minimal and fast)
- Custom aliases
- History configuration
- High-precision time command

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