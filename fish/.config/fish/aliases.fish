# Basic
alias ls lsd
alias ll 'ls -l'
alias la 'ls -a'
alias lla 'ls -la'
alias lt 'ls -a --tree --ignore-glob .git --ignore-glob node_modules --ignore-glob .next'

# Git
alias ga 'git add .'
alias gap 'git add -p'
alias gc 'git commit -m'
alias gs 'git status'
alias gp 'git push'
alias gfp 'git fetch --all && git pull'
alias lg lazygit

# Utils
alias vim nvim

# Functions
function sshr
    TERM=xterm-color ssh $argv
end
