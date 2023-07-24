#!/bin/zsh
HISTSIZE=1000000
SAVEHIST=1000000

# MacOS
export PATH=/sbin:/bin:/usr/sbin:/usr/bin:/opt/homebrew/bin:/opt/homebrew/sbin

# Global npm installs without sudo
NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"
export MANPATH="${MANPATH-$(manpath)}:${NPM_PACKAGES}/share/man"

export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="firefox"

# Linux Wayland
# export XDG_CURRENT_DESKTOP="Wayland"
