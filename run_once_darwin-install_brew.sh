#!/bin/sh

if command -v brew >/dev/null 2>&1; then
  echo "Running brew bundle..."
  brew bundle --file="$HOME/Brewfile"
else
  echo "Homebrew not installed, skipping brew bundle."
fi

