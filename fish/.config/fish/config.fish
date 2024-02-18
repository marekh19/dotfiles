if status is-interactive
    # Commands to run in interactive sessions can go here
end

source $HOME/.config/fish/aliases.fish
source $HOME/.config/fish/tokyo_night.fish
source $HOME/.config/fish/pfetch.fish

set -g fish_greeting

set -x N_PREFIX "$HOME/n"
contains "$N_PREFIX/bin" $PATH; or set -a PATH "$N_PREFIX/bin" # Added by n-install (see http://git.io/n-install-repo).

starship init fish | source

pfetch
