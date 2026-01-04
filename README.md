# Dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## New Mac Setup

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install dependencies

```bash
brew install fish zoxide yazi nvim gpg tmux btop starship
brew install --cask wezterm aerospace
```

### 3. Set fish as default shell

```bash
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

### 4. Install chezmoi and apply dotfiles

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply kennethx
```

This will:
- Clone this repo
- Apply all dotfiles
- Auto-install fisher and plugins (via `run_once` script)
- Auto-install yazi plugins (via `run_once` script)

## Daily Usage

| Task | Command |
|------|---------|
| Preview changes | `chezmoi diff` |
| Apply changes | `chezmoi apply` |
| Pull + apply updates | `chezmoi update` |
| Add new file | `chezmoi add ~/.config/xxx` |
| Edit managed file | `chezmoi edit ~/.config/xxx` |
| Re-sync from target | `chezmoi re-add ~/.config/xxx` |

## What's Included

- **fish** - Shell config + plugins (pure theme)
- **nvim** - Neovim config
- **tmux** - Terminal multiplexer config
- **yazi** - File manager config
- **aerospace** - Window manager
- **wezterm** - Terminal emulator
- **zed** - Editor config
- **starship** - Prompt theme
- **btop** - System monitor
- **borders** - Window borders
