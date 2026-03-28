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

# --- XDG Base Directory Specification ---
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Redirect Zsh history and state to XDG-compliant locations
export HISTFILE="${XDG_STATE_HOME}/zsh/zsh_history"
mkdir -p "${XDG_STATE_HOME}/zsh" 2>/dev/null

# Set the path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# 1Password secret references are loaded from .env.local (untracked).
# To configure, add to your .env.local:
#   export OP_LITELLM_SECRET_PATH='op://My Vault/LiteLLM/LITELLM_TOKEN'

# Add Homebrew to PATH directly.
# Prepend the bin paths explicitly rather than using `brew shellenv`,
# because `brew shellenv` calls /usr/libexec/path_helper which can reset PATH
# when no /etc/paths.d/homebrew entry exists (e.g. on this machine).
if [ -d "/opt/homebrew/bin" ]; then # Apple Silicon Macs
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
  export HOMEBREW_REPOSITORY="/opt/homebrew"
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
  [[ ":$PATH:" != *":/opt/homebrew/bin:"* ]] && export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
elif [ -d "/usr/local/bin" ] && [ -f "/usr/local/bin/brew" ]; then # Intel Macs
  export HOMEBREW_PREFIX="/usr/local"
  export HOMEBREW_CELLAR="/usr/local/Cellar"
  export HOMEBREW_REPOSITORY="/usr/local/Homebrew"
  [[ ":$PATH:" != *":/usr/local/bin:"* ]] && export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
elif [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then # Linux / Codespaces
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
  export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar"
  export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew"
  [[ ":$PATH:" != *":/home/linuxbrew/.linuxbrew/bin:"* ]] && export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi

# Always source main-env.zsh for environment variables (EDITOR, PATH, etc.)
if [ -n "$DOTFILES_DIR" ] && [ -f "$DOTFILES_DIR/xdg/.config/zsh/environment/main-env.zsh" ]; then
  source "$DOTFILES_DIR/xdg/.config/zsh/environment/main-env.zsh"
fi
. "$HOME/.cargo/env"
