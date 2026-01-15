#!/bin/bash
# Claude Code notification helper with Kitty tab context

# Check if running in Kitty terminal by traversing process tree
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

# Only send notification if running in Kitty terminal
if ! is_kitty_session; then
    exit 0
fi

MESSAGE="$1"
KITTY_CONTEXT_FILE="/tmp/claude_kitty_context_$$"

# Try to get Kitty tab title from saved context or current environment
TAB_TITLE=""

# First try: Read from session context file (saved by session-start hook)
# The session_id from stdin can help find the right context file
if [[ -t 0 ]]; then
    # No stdin, try environment variable
    WINDOW_ID="$KITTY_WINDOW_ID"
else
    # Read stdin to get session info
    INPUT=$(cat)
    SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null)
    if [[ -n "$SESSION_ID" ]] && [[ -f "/tmp/claude_kitty_${SESSION_ID}" ]]; then
        WINDOW_ID=$(cat "/tmp/claude_kitty_${SESSION_ID}")
    else
        WINDOW_ID="$KITTY_WINDOW_ID"
    fi
fi

# Find Kitty socket (has PID suffix like /tmp/kitty_term-1262)
KITTY_SOCKET=""
for sock in /tmp/kitty_term-*; do
    if [[ -S "$sock" ]]; then
        KITTY_SOCKET="$sock"
        break
    fi
done

# Get tab title from Kitty if we have a window ID and socket
if [[ -n "$WINDOW_ID" ]] && [[ -n "$KITTY_SOCKET" ]] && command -v kitty &> /dev/null; then
    TAB_TITLE=$(kitty @ --to "unix:${KITTY_SOCKET}" ls 2>/dev/null | jq -r --arg id "$WINDOW_ID" \
        '.[] | .tabs[] | .windows[] | select(.id == ($id | tonumber)) | .title' 2>/dev/null)
fi

# Build notification title
if [[ -n "$TAB_TITLE" ]]; then
    TITLE="Claude in kitty: $TAB_TITLE"
else
    TITLE="Claude Code"
fi

# Send notification
osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\" sound name \"Ping\""
