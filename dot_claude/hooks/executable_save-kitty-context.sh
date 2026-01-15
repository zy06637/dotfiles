#!/bin/bash
# Save Kitty window ID for later use in notifications

# Read session info from stdin
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null)

# Save KITTY_WINDOW_ID if available
if [[ -n "$SESSION_ID" ]] && [[ -n "$KITTY_WINDOW_ID" ]]; then
    echo "$KITTY_WINDOW_ID" > "/tmp/claude_kitty_${SESSION_ID}"
fi
