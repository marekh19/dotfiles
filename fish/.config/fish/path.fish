# Environment and PATH setup

# Homebrew – sets PATH, MANPATH, etc.
eval (/opt/homebrew/bin/brew shellenv)

# PNPM
set -gx PNPM_HOME "$HOME/Library/pnpm"
fish_add_path $PNPM_HOME

# Local bin
fish_add_path $HOME/.local/bin

# Go (GOPATH/bin) – tiny guard so shells don't error if you ever uninstall Go
if command -q go
    set -l gopath (go env GOPATH)
    fish_add_path $gopath/bin
end

# PostgreSQL
fish_add_path /opt/homebrew/opt/postgresql@15/bin
