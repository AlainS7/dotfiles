#!/bin/zsh

# Add custom scripts directory and local bin to PATH
mkdir -p ~/.local/bin
export PATH="$HOME/.local/bin:${DOTFILES_DIR}/scripts:$PATH"
