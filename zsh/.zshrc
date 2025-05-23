# Set the directory to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Add homebrew apps to path
eval "$(/opt/homebrew/bin/brew shellenv)"

# Add local bin to path
export PATH="$HOME/.local/bin:$PATH"

# Add go programs to path
export PATH=$PATH:$(go env GOPATH)/bin

# postgresql
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

# Download zinit if it's not already installed
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Source aliases
source ~/.zsh_aliases

# Source fzf theme
source ~/.config/fzf/themes/catppuccin-mocha.sh

# Load completions
autoload -Uz compinit
compinit

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit ice atload"zpcdreplay" atclone"./zplug.zsh" atpull"%atclone"
zinit light g-plane/pnpm-shell-completion

zinit cdreplay -q

# Keybindings
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# History
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Syntax highlighting catppuccin theme
source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

# Shell integrations
eval "$(fzf --zsh)"

# Load Starship
eval "$(starship init zsh)"

# Load zoxide
eval "$(zoxide init --cmd cd zsh)"

# Show pfetch
pfetch

# pnpm
export PNPM_HOME="/Users/marekhonzal/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

