if status is-interactive
    # Commands to run in interactive sessions can go here
end

source $HOME/.config/fish/aliases.fish
source $HOME/.config/fish/tokyo_night.fish

set -g fish_greeting

set -x N_PREFIX "$HOME/n"
contains "$N_PREFIX/bin" $PATH; or set -a PATH "$N_PREFIX/bin" # Added by n-install (see http://git.io/n-install-repo).

set PATH $PATH opt/homebrew/bin
set PATH $PATH opt/homebrew/sbin

starship init fish | source

neofetch
