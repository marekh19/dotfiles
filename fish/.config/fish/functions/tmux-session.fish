# Bootstraps a tmux session with three windows:
#   1. shell  – 4 panes in a tiled 2×2 layout
#   2. nvim   – neovim ready to go
#   3. claude – claude CLI
# Usage: tmux-session <session-name>

function tmux-session
    if test (count $argv) -eq 0
        echo "Usage: tmux-session <session-name>"
        return 1
    end

    set session $argv[1]

    # Bail if session already exists
    if tmux has-session -t $session 2>/dev/null
        echo "Session '$session' already exists."
        return 1
    end

    # ── Window 1: shell (4 panes) ────────────────────────────────────────────────
    tmux new-session -d -s $session -n shell

    # Split right → left|right
    tmux split-window -h -t $session:1

    # Split each half horizontally → 4 panes total
    tmux split-window -v -t $session:1.1
    tmux split-window -v -t $session:1.2

    # Even out the panes
    tmux select-layout -t $session:1 tiled

    # ── Window 2: nvim ───────────────────────────────────────────────────────────
    tmux new-window -t $session -n nvim
    tmux send-keys -t $session:2 nvim Enter

    # ── Window 3: claude ─────────────────────────────────────────────────────────
    tmux new-window -t $session -n claude
    tmux send-keys -t $session:3 claude Enter

    # Focus window 1, top-left pane
    tmux select-window -t $session:1
    tmux select-pane -t $session:1.1

    tmux attach-session -t $session
end
