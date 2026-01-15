#!/bin/bash
# Clean up Kitty context file when session ends

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null)

if [[ -n "$SESSION_ID" ]] && [[ -f "/tmp/claude_kitty_${SESSION_ID}" ]]; then
    rm -f "/tmp/claude_kitty_${SESSION_ID}"
fi
