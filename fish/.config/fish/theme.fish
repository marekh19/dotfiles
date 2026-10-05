# Color theme. Switch with `theme <name>`; see "Theming" in the README.
set -q dotfiles_theme; or set -U dotfiles_theme meowsoot

# Writes a generated include file only when its content changes, and only when
# the tool's config directory exists.
function __theme_write --argument-names file
    path is -d (path dirname $file); or return
    set -l content (string join \n -- $argv[2..])
    test "$content" = "$(cat $file 2>/dev/null | string collect)"; and return
    printf '%s\n' $argv[2..] >$file
end

# Runs again in every open shell when the universal variable changes.
function __theme_apply --on-variable dotfiles_theme
    set -l name $dotfiles_theme

    # No --color-theme: themes without [dark]/[light] sections fail with it.
    fish_config theme choose $name

    set -gx BAT_THEME $name
    set -gx THEME_NVIM $name

    # Only point at files that exist; fzf errors on a missing options file.
    set -e FZF_DEFAULT_OPTS_FILE LG_CONFIG_FILE
    set -l fzf ~/.config/fzf/themes/$name.conf
    test -f $fzf; and set -gx FZF_DEFAULT_OPTS_FILE $fzf

    set -l lazygit ~/.config/lazygit/themes/$name.yml
    if test -f $lazygit
        set -l lazygit_dir ~/.config/lazygit
        test (uname) = Darwin; and set lazygit_dir ~/Library/Application\ Support/lazygit
        # Theme first, so config.yml overrides non-color options in theme files.
        set -gx LG_CONFIG_FILE "$lazygit,$lazygit_dir/config.yml"
    end

    # Ghostty and Git cannot read environment variables.
    __theme_write ~/.config/ghostty/current-theme "theme = $name"
    __theme_write ~/.config/git/current-theme.gitconfig \
        '[include]' "  path = ~/.config/git/themes/$name.gitconfig" \
        '[delta]' "  syntax-theme = $name"
end

__theme_apply
