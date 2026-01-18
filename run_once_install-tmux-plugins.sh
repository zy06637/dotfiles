#!/bin/bash

# 安装 TPM
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# 安装 catppuccin 主题（如果你是手动装的）
if [ ! -d "$HOME/.config/tmux/plugins/catppuccin" ]; then
  echo "Installing catppuccin theme..."
  mkdir -p ~/.config/tmux/plugins
  git clone https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
fi

# 自动安装 TPM 插件（无需手动 prefix + I）
if [ -f "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
  echo "Installing tmux plugins..."
  ~/.tmux/plugins/tpm/bin/install_plugins
fi
