# ls -> eza
function ls
    command eza --color=always --icons=always $argv
end

# ls
abbr --add ll 'ls -l'
abbr --add la 'ls -a'
abbr --add lla 'ls -la'
abbr --add lt 'ls -a --tree --ignore-glob .git --ignore-glob node_modules --ignore-glob .next'

# Git
abbr --add g git
abbr --add ga 'git add'
abbr --add gaa 'git add --all'
abbr --add gap 'git add -p'
abbr --add gc 'git commit -m'
abbr --add gs 'git status'
abbr --add gp 'git push'
abbr --add gpf 'git push --force-with-lease'
abbr --add gf 'git fetch --prune'
abbr --add gfa 'git fetch --prune --all'
abbr --add gl 'git log'

# Tmux
abbr --add tm 'tmux attach || tmux new session'
abbr --add tmks 'tmux kill-server'
abbr --add tmls 'tmux ls'
abbr --add tmns 'tmux new-session -s'

# Brew
abbr --add bi 'brew install'
abbr --add bls 'brew list'
abbr --add bu 'brew update'
abbr --add bup 'brew upgrade'

# Nvim
abbr --add v nvim
abbr --add vim nvim

# Pnpm
abbr --add p pnpm
abbr --add pi 'pnpm install'
abbr --add pa 'pnpm add'
abbr --add pad 'pnpm add -D'
abbr --add pu 'pnpm update'
abbr --add pui 'pnpm update --interactive'
abbr --add puil 'pnpm update --interactive --latest'
abbr --add pd 'pnpm run dev'
abbr --add pb 'pnpm run build'
abbr --add pt 'pnpm run test'

# Cursor agent
abbr --add ca cursor-agent

# Lazy Git / Docker
abbr --add lg lazygit
abbr --add ld lazydocker

# Utility
abbr --add .. 'cd ..'
abbr --add ... 'cd ../..'
abbr --add abbr 'bat ~/.config/fish/abbrs.fish'

## Fish
abbr --add f fish

## Fisher
abbr --add fr fisher
abbr --add fri 'fisher install'
abbr --add frl 'fisher list'
