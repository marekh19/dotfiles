# Core environment / PATH (also for non-interactive shells)
source ~/.config/fish/path.fish

# Only run the rest in interactive sessions
if status is-interactive
    source ~/.config/fish/abbrs.fish
    source ~/.config/fish/tools.fish
end
