function theme --description "Switch the color theme: theme <name>"
    if not set -q argv[1]
        echo $dotfiles_theme
        return
    end

    if not contains -- $argv[1] (fish_config theme list)
        echo "theme: no Fish theme named '$argv[1]'. See `fish_config theme list`." >&2
        return 1
    end

    set -U dotfiles_theme $argv[1]
    echo "Reload Ghostty (cmd+shift+,) and restart Neovim"
end
