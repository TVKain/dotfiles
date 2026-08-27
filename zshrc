# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Add starship to PATH
export PATH="$HOME/.local/bin:$PATH"

# Initialize starship prompt
eval "$(starship init zsh)"

# Initialize zoxide (smart cd command)
eval "$(zoxide init zsh)"

# Override cd with zoxide z command for smart navigation
alias cd='z'

# Initialize completion system
autoload -U compinit; compinit

# Enable fzf-tab for better completion
if [ -f ~/.local/share/fzf-tab/fzf-tab.plugin.zsh ]; then
    source ~/.local/share/fzf-tab/fzf-tab.plugin.zsh
    
    # Configure fzf-tab
    zstyle ':completion:*' menu no
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS
    
    # Accept exact matches
    zstyle ':completion:*' accept-exact '*(N)'
    zstyle ':completion:*' use-cache on
    zstyle ':completion:*' cache-path ~/.zcompcache
    
    # Group and sort completions
    zstyle ':completion:*' group-name ''
    zstyle ':completion:*:descriptions' format '[%d]'
    
    # Case-insensitive matching
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
    
    # Add fzf+zoxide for interactive directory selection
    # Use 'zi' command for interactive directory selection
    zi() {
        local dir
        dir=$(zoxide query -l "$@" | fzf +m --height 50% --border)
        cd "$dir"
    }
fi

# Minimal zsh configuration for better performance
# Disable slow features
setopt NO_BEEP
setopt NO_HUP
setopt NO_CHECK_JOBS

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Custom aliases
alias ll='ls -la'
alias la='ls -A'
alias l='ls -1'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# History configuration
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# Time format configuration
TIMEFMT="%J  %*U user %*S system %P cpu %*E total"

# Local configuration (machine-specific, not committed)
# Create ~/.zshrc.local for your local settings, aliases, and credentials
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi
