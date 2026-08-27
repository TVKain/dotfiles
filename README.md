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
- Leaf (terminal markdown previewer)
- Bat (cat clone with syntax highlighting)
- Clangd (LSP for C/C++)
- Node.js and npm (via NodeSource LTS)
- Tmux plugins (via TPM): tmux-sensible, tmux-tilish, catppuccin theme
- Vim plugins (via vim-plug)
- fzf (fuzzy finder)
- ripgrep (fast search tool)
- zoxide (smart cd command)
- fzf-tab (enhanced tab completion with fzf)
- zsh-autosuggestions (command suggestions as you type)

## Manual Setup

After installation, you may need to:

1. **Tmux plugins**: The installer automatically installs tmux plugins via TPM. If needed, manually install by pressing `Ctrl+B` then `Shift+I` in tmux
2. **Vim plugins**: The installer automatically runs `:PlugInstall`, but you can manually run it in vim if needed

## Configuration Files

- `zshrc` → `~/.zshrc`
- `tmux.conf` → `~/.tmux.conf`
- `vimrc` → `~/.vimrc`
- `config/starship.toml` → `~/.config/starship.toml`

Note: The `~/.vim/` directory is created automatically by vim-plug during plugin installation.

## Local Configuration

For machine-specific settings, credentials, and local overrides:

1. Copy the example file:
   ```bash
   cp ~/dotfiles/zshrc.local.example ~/.zshrc.local
   ```

2. Edit `~/.zshrc.local` with your local settings:
   - API keys and credentials
   - Local aliases
   - Machine-specific environment variables
   - Local functions

3. The file is automatically sourced by `.zshrc` and is gitignored

**Note:** Never commit sensitive information to the repository. Use `~/.zshrc.local` for credentials and machine-specific configuration.

## Backup

The installer automatically backs up existing configurations to:
`/tmp/dotfiles_backup_YYYYMMDD_HHMMSS/`

The backup location is displayed during installation and in the completion message. Note that backups are stored in `/tmp/` and may be cleared on system restart.

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
- Custom aliases (including `cat` aliased to `bat` for syntax highlighting)
- History configuration
- High-precision time command
- zoxide integration (cd is aliased to zoxide for smart directory navigation)
- fzf-tab for enhanced tab completion (fzf-powered with vim navigation)
- zsh-autosuggestions for command suggestions as you type (Ctrl+Space to accept)
- Interactive directory selection with 'zi' command (fzf+zoxide with border)
- Local configuration support via ~/.zshrc.local

### Tmux
- Mouse support with scroll wheel
- Catppuccin theme
- tmux-tilish plugin for i3-style keybindings (Alt+x for new pane, Alt+0-9 for window switching, Alt+hjkl for navigation)
- Alt+Enter remapped to Alt+x to avoid WSL zoom and Windows settings pane conflicts
- Window and pane numbering starting from 1 instead of 0
- Automatic window renumbering
- Scroll mode (copy mode): Alt+q to enter, q to exit, vi-style keybindings (j/k to scroll)
- Custom help popup: Alt+/ to show common keybindings (stays open until q or Esc)
- Plugin support via TPM

### Vim
- Plugin management via vim-plug
- Custom configuration
- Syntax highlighting and more
- Leaf markdown preview integration (use `\md` to preview markdown files)

### Starship
- Minimal prompt with Catppuccin Mocha color scheme
- Git branch display
- Username and hostname display
- Performance optimized

### Development Tools
- Clangd (LSP for C/C++ development)
- Node.js and npm (LTS version via NodeSource)
- Ready for web development and C/C++ development

### Leaf (Terminal Markdown Previewer)
- GUI-like markdown preview in terminal
- Live preview with watch mode
- Fuzzy file picker for markdown files
- Syntax highlighting for code blocks
- Support for tables, lists, blockquotes, and more
- LaTeX and Mermaid diagram support
- Custom themes available
- Vim integration available

**Usage:**
```bash
# Preview a markdown file
leaf README.md

# Watch mode (auto-reload on save)
leaf -w README.md

# Open fuzzy file picker
leaf

# Render to stdout (for pipes)
leaf --inline README.md
```

### Bat (Cat Clone with Syntax Highlighting)
- Syntax highlighting for many programming and markup languages
- Git integration to show file modifications
- Automatic paging for large files
- Show non-printable characters
- File concatenation support
- Integration with fzf, ripgrep, and other tools
- `cat` is aliased to `bat --paging=never` for seamless replacement

**Usage:**
```bash
# View a file with syntax highlighting
bat README.md

# View multiple files
bat src/*.rs

# Show line numbers
bat -n main.rs

# Show non-printable characters
bat -A /etc/hosts

# Use as cat replacement (already aliased)
cat file.txt
```