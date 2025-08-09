unsetopt KSH_GLOB
# ~/.zshenv
#
# This file is sourced on every shell startup, including non-interactive shells.
# It should be used for setting essential environment variables that all
# shell processes need, like $PATH, $EDITOR, etc.
#
# For a clean, XDG-compliant setup, this file sets the stage for Zsh
# to find its configuration files in xdg/.config/zsh.

# In zsh, ${(%):-%x} expands to the path of the file being sourced.
# Use realpath to resolve the symlink to its target file.
# Try to determine DOTFILES_DIR robustly for local, Codespaces, and fallback scenarios
if [ -n "${(%):-%x}" ] && [ -f "${(%):-%x}" ]; then
  export DOTFILES_DIR="$(dirname "$(dirname "$(realpath "${(%):-%x}")")")"
elif [ -d "$HOME/dotfiles" ]; then
  export DOTFILES_DIR="$HOME/dotfiles"
elif [ -d "/workspaces/.codespaces/.persistedshare/dotfiles" ]; then
  export DOTFILES_DIR="/workspaces/.codespaces/.persistedshare/dotfiles"
else
  export DOTFILES_DIR=""
fi
if [ -z "$DOTFILES_DIR" ]; then
  echo "[.zshenv] WARNING: DOTFILES_DIR is not set. Please set it to your dotfiles directory." >&2
fi

# Set the ZDOTDIR to the XDG-compliant configuration directory.
# This tells Zsh where to find its config files (.zshrc, .zprofile, etc.).
export ZDOTDIR="$DOTFILES_DIR/xdg/.config/zsh"

# Set the path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"


# Add Homebrew to the PATH.
# This ensures that `brew` and its installed packages are available.
if [ -f "/opt/homebrew/bin/brew" ]; then # Apple Silicon Macs
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f "/usr/local/bin/brew" ]; then # Intel Macs
  eval "$(/usr/local/bin/brew shellenv)"
elif [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then # Linux / Codespaces
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Always source main-env.zsh for environment variables (EDITOR, PATH, etc.)
if [ -n "$DOTFILES_DIR" ] && [ -f "$DOTFILES_DIR/xdg/.config/zsh/environment/main-env.zsh" ]; then
  source "$DOTFILES_DIR/xdg/.config/zsh/environment/main-env.zsh"
fi
