#!/bin/bash
# Claude Code notification helper with tmux/kitty context
# Priority: tmux > kitty > ignore others
# Skips notification in headless mode (claude -p)

# 无头模式检测 - claude -p 不需要通知
is_headless_mode() {
    local pid=$PPID
    local depth=0
    while [[ $pid -gt 1 ]] && [[ $depth -lt 10 ]]; do
        local cmdline=$(ps -o command= -p $pid 2>/dev/null)
        if [[ "$cmdline" == *"claude"* ]] && [[ "$cmdline" == *" -p"* || "$cmdline" == *" --print"* ]]; then
            return 0
        fi
        pid=$(ps -o ppid= -p $pid 2>/dev/null | tr -d ' ')
        ((depth++))
    done
    return 1
}

if is_headless_mode; then
    exit 0
fi

MESSAGE="$1"
TITLE=""

# Read hook input from stdin
HOOK_INPUT=$(cat)

# Debug: log hook input to temp file (remove after debugging)
echo "$(date): $HOOK_INPUT" >> /tmp/claude_notify_debug.log

# Check if running in headless mode
# Method 1: Custom env var (set CLAUDE_HEADLESS=1 in your script)
if [[ "$CLAUDE_HEADLESS" == "1" ]]; then
    exit 0
fi

# Method 2: Check permission_mode (for --dangerously-skip-permissions)
PERMISSION_MODE=$(echo "$HOOK_INPUT" | jq -r '.permission_mode // empty' 2>/dev/null)
if [[ "$PERMISSION_MODE" == "dontAsk" ]] || [[ "$PERMISSION_MODE" == "bypassPermissions" ]]; then
    exit 0
fi

# Priority 1: Check if running in tmux
if [[ -n "$TMUX" ]]; then
    SESSION_NAME=$(tmux display-message -p '#S' 2>/dev/null)
    WINDOW_NAME=$(tmux display-message -p '#W' 2>/dev/null)
    WINDOW_INDEX=$(tmux display-message -p '#I' 2>/dev/null)

    if [[ -n "$SESSION_NAME" ]] && [[ -n "$WINDOW_NAME" ]]; then
        TITLE="Claude [$SESSION_NAME:$WINDOW_INDEX] $WINDOW_NAME"
    elif [[ -n "$SESSION_NAME" ]]; then
        TITLE="Claude [$SESSION_NAME]"
    fi
fi

# Priority 2: Check if running directly in Kitty (only if not in tmux)
if [[ -z "$TITLE" ]]; then
    # Check if running in Kitty by traversing process tree
    is_kitty_session() {
        local pid=$PPID
        local depth=0
        while [[ $pid -gt 1 ]] && [[ $depth -lt 10 ]]; do
            local cmdline=$(ps -o command= -p $pid 2>/dev/null)
            if [[ "$cmdline" == *"kitty"* ]]; then
                return 0
            fi
            if [[ "$cmdline" == *"claude-code-acp"* ]] || [[ "$cmdline" == *"/Zed"* ]]; then
                return 1
            fi
            pid=$(ps -o ppid= -p $pid 2>/dev/null | tr -d ' ')
            ((depth++))
        done
        return 1
    }

    if is_kitty_session; then
        # Try to get session_id from hook input to find saved Kitty window ID
        SESSION_ID=$(echo "$HOOK_INPUT" | jq -r '.session_id // empty' 2>/dev/null)
        if [[ -n "$SESSION_ID" ]] && [[ -f "/tmp/claude_kitty_${SESSION_ID}" ]]; then
            WINDOW_ID=$(cat "/tmp/claude_kitty_${SESSION_ID}")
        else
            WINDOW_ID="$KITTY_WINDOW_ID"
        fi

        # Find Kitty socket
        KITTY_SOCKET=""
        for sock in /tmp/kitty_term-*; do
            if [[ -S "$sock" ]]; then
                KITTY_SOCKET="$sock"
                break
            fi
        done

        # Get tab title from Kitty
        TAB_TITLE=""
        if [[ -n "$WINDOW_ID" ]] && [[ -n "$KITTY_SOCKET" ]] && command -v kitty &> /dev/null; then
            TAB_TITLE=$(kitty @ --to "unix:${KITTY_SOCKET}" ls 2>/dev/null | jq -r --arg id "$WINDOW_ID" \
                '.[] | .tabs[] | .windows[] | select(.id == ($id | tonumber)) | .title' 2>/dev/null)
        fi

        if [[ -n "$TAB_TITLE" ]]; then
            TITLE="Claude [kitty] $TAB_TITLE"
        else
            TITLE="Claude [kitty]"
        fi
    fi
fi

# If not in tmux or kitty, exit without notification
if [[ -z "$TITLE" ]]; then
    exit 0
fi

# Send notification
osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"Ping\""
