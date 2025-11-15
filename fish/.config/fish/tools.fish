# Interactive tooling: prompt, navigation, extras

# No default fish greeting
set -g fish_greeting ""

# Starship prompt
if command -q starship
    starship init fish | source
end

# zoxide (smart cd)
if command -q zoxide
    zoxide init fish --cmd cd | source
end

# fzf keybindings & completion
if command -q fzf
    fzf --fish | source
end

# System info on shell start
if command -q pfetch
    pfetch
end
