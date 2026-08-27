# AGENTS.md

This file contains information for AI agents working on this dotfiles repository.

## Repository Overview

Personal dotfiles for Ubuntu 24.04+ with WSL support. Includes zsh, tmux, vim, and starship configurations.

## Repository Structure

```
.
├── install.sh           # Main installation script
├── tmux.conf           # Tmux configuration
├── vimrc               # Vim configuration
├── zshrc               # Zsh configuration
├── zshrc.local.example # Example local configuration (gitignored)
├── config/
│   └── starship.toml   # Starship prompt configuration
└── AGENTS.md           # This file
```

## Installation Process

The installation is handled by `install.sh`:

```bash
./install.sh
```

The installer:
1. Checks OS support (Ubuntu 24.04+)
2. Prompts for confirmation (upgrade vs fresh install)
3. Backs up existing configurations to `/tmp/dotfiles_backup_YYYYMMDD_HHMMSS/`
4. Removes existing configurations
5. Installs dependencies via apt and curl
6. Copies dotfiles to home directory
7. Sets zsh as default shell
8. Installs tmux plugins via TPM
9. Installs vim plugins via vim-plug
10. Creates installation marker at `~/.dotfiles_installed`

## Verification Commands

After making changes, verify the installation works:

```bash
# Test the installer (dry run or actual install)
./install.sh

# Check if tmux plugins are installed
ls -la ~/.tmux/plugins/

# Check if vim plugins are installed
ls -la ~/.vim/plugged/

# Verify zsh configuration
zsh -c 'echo $ZSH_VERSION'

# Test tmux configuration
tmux source-file ~/.tmux.conf

# Test vim configuration
vim +PlugStatus +qall
```

## Key Dependencies

The installer handles these dependencies:

### System packages (via apt):
- git, curl, zsh, vim, tmux, bat
- fzf, ripgrep
- clangd (LSP for C/C++)

### Language runtimes:
- Node.js and npm (via NodeSource setup_lts.x)

### Shell tools:
- zoxide (smart cd command)
- starship (prompt)
- leaf (terminal markdown previewer)

### Tmux plugins (via TPM):
- tmux-sensible
- tmux-tilish (i3-style keybindings)
- catppuccin (theme)

### Vim plugins (via vim-plug):
- Defined in vimrc

### Zsh plugins:
- fzf-tab (enhanced completion)
- zsh-autosuggestions

## Configuration Files

### tmux.conf
- Uses tmux-tilish for i3-style keybindings
- Alt+hjkl for navigation
- Alt+x for new pane
- Alt+0-9 for window switching (handled by tmux-tilish)
- Alt+Shift+0-9 for moving panes (handled by tmux-tilish)
- Alt+q for scroll mode
- Alt+/ for help popup
- Catppuccin mocha theme
- Mouse support enabled

### vimrc
- Uses vim-plug for plugin management
- Leaf markdown preview integration (`\md` to preview)
- Custom keybindings and configuration

### zshrc
- Starship prompt
- Aliases (cat → bat, cd → zoxide)
- fzf-tab integration
- zsh-autosuggestions
- Local configuration support via `~/.zshrc.local`

### config/starship.toml
- Catppuccin mocha color scheme
- Git branch display
- Username and hostname display

## Platform-Specific Considerations

### WSL (Windows Subsystem for Linux)
- Alt+Enter remapped to Alt+x in tmux to avoid WSL zoom conflict
- Windows Alt+Space conflict handled by tmux-tilish remap
- Path handling may differ from native Linux

### Ubuntu 24.04+
- Only supported OS version
- Uses apt package manager
- Requires sudo privileges

## Common Tasks

### Adding a new dependency
1. Add installation logic to `install_dependencies()` function in install.sh
2. Check if already installed with `command -v`
3. Use appropriate installation method (apt, curl, etc.)
4. Update README.md "What gets installed" section

### Modifying tmux configuration
1. Edit tmux.conf
2. Test with: `tmux source-file ~/.tmux.conf`
3. If adding plugins, add to plugin list in tmux.conf
4. TPM will handle plugin installation

### Modifying vim configuration
1. Edit vimrc
2. Add plugins to vim-plug section if needed
3. Test with: `vim +PlugInstall +qall`

### Modifying zsh configuration
1. Edit zshrc
2. Test with: `source ~/.zshrc`
3. For machine-specific settings, use `~/.zshrc.local`

## Keybindings Reference

### Tmux (tmux-tilish)
- Alt+h/j/k/l: Navigate panes
- Alt+x: New pane
- Alt+0-9: Switch windows
- Alt+Shift+0-9: Move panes
- Alt+q: Enter scroll mode
- Alt+/: Show help popup
- Alt+Shift+q: Close pane
- Alt+Shift+e: Detach

### Vim
- Defined in vimrc
- `\md`: Preview markdown with leaf

### Zsh
- Ctrl+Space: Accept autosuggestion
- Tab: fzf-tab completion
- `zi`: Interactive directory selection

## Local Configuration

Machine-specific settings should go in `~/.zshrc.local`:
- API keys and credentials
- Local aliases
- Machine-specific environment variables
- Local functions

This file is automatically sourced by zshrc and is gitignored.

## Troubleshooting

### Tmux plugins not installing
- Ensure TPM is installed: `ls -la ~/.tmux/plugins/tpm`
- Manually install: `~/.tmux/plugins/tpm/bin/install_plugins`
- Check tmux config is sourced: `tmux source-file ~/.tmux.conf`

### Vim plugins not installing
- Ensure vim-plug is installed: `ls -la ~/.vim/autoload/plug.vim`
- Manually install: `vim +PlugInstall +qall`

### Installation marker issues
- Remove marker: `rm ~/.dotfiles_installed`
- Re-run installer for fresh install

### WSL-specific issues
- Check if Alt+Enter remap is working in tmux
- Verify Windows terminal settings if keybindings don't work

## Testing Changes

When making changes to the installer or configurations:

1. Test in a clean environment if possible
2. Run the full installation script
3. Verify all dependencies are installed
4. Test each application (zsh, tmux, vim)
5. Check keybindings work as expected
6. Verify plugins are loaded
7. Test on WSL if applicable

## Build/Release Process

This is a configuration repository, not a compiled project. Changes are:
1. Made directly to configuration files
2. Committed to git
3. Tagged for version control if needed
4. Users re-run install.sh to update

## Git Workflow

- Main branch: main
- No automated CI/CD
- Manual testing required
- Installation marker tracks version for upgrades
