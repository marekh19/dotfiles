function screenshot-shadow --description 'Show or set macOS screenshot window shadows'
    switch "$argv[1]"
        case on
            defaults delete com.apple.screencapture disable-shadow 2>/dev/null
        case off
            defaults write com.apple.screencapture disable-shadow -bool true
        case status ''
            # fall through to the status report below
        case '*'
            echo "Usage: screenshot-shadow [on|off|status]" >&2
            return 1
    end

    # An unset or false disable-shadow both mean shadows are on.
    if test "$(defaults read com.apple.screencapture disable-shadow 2>/dev/null)" = 1
        echo "Screenshot shadows: off"
    else
        echo "Screenshot shadows: on"
    end
end
