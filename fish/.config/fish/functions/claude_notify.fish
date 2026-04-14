#!/opt/homebrew/bin/fish
#
# Claude Code notification hook — native macOS system notifications
#
# Hooked into Claude Code's Stop and Notification events via settings.json.
# Differentiates between the two so you know whether Claude finished or
# is waiting for you to make a choice.
#
# Usage (called automatically by Claude Code, or manually for testing):
#   fish claude_notify.fish stop
#   fish claude_notify.fish notification   # reads JSON from stdin

# Determine which tmux session we're in, for context in the notification body
if set -q TMUX
    set session_name (tmux display-message -p '#S')
else
    set session_name Unknown
end

switch $argv[1]
    case stop
        # Claude finished its task and handed control back to you
        set title "Claude Code — Done"
        set message "Task finished in session: $session_name"

    case notification
        # Claude is blocked and needs you to approve something or make a choice.
        # The hook pipes a JSON payload via stdin; extract the message field.
        set input (cat)
        set claude_message (echo $input | jq -r '.message // "Needs your attention"')
        set title "Claude Code — Waiting"
        set message "$claude_message (session: $session_name)"

    case '*'
        set title "Claude Code"
        set message "Event in session: $session_name"
end

osascript -e "display notification \"$message\" with title \"$title\" sound name \"default\""
