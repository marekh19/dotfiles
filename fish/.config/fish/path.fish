# Environment and PATH setup

# Homebrew – sets PATH, MANPATH, etc. when installed.
if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
else if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
else if command -q brew
    eval (brew shellenv)
end

# PNPM
if not set -q PNPM_HOME
    if set -q XDG_DATA_HOME
        set -gx PNPM_HOME "$XDG_DATA_HOME/pnpm"
    else if test (uname) = Darwin
        set -gx PNPM_HOME "$HOME/Library/pnpm"
    else
        set -gx PNPM_HOME "$HOME/.local/share/pnpm"
    end
end
fish_add_path $PNPM_HOME

# Local bin
fish_add_path $HOME/.local/bin

# Go (GOPATH/bin) – tiny guard so shells don't error if you ever uninstall Go
if command -q go
    set -l gopath (go env GOPATH)
    fish_add_path $gopath/bin
end

# Bun
set -gx BUN_INSTALL "$HOME/.bun"
fish_add_path $BUN_INSTALL/bin

# opencode
fish_add_path $HOME/.opencode/bin

# fnm – must come after brew shellenv so fnm's bin takes precedence over /opt/homebrew/bin/node
if command -q fnm
    fnm env --use-on-cd --shell fish | source
end
