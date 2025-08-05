
# --------------------------------------------------------------------
# >> ENVIRONMENT VARIABLES & SHELL OPTIONS
# --------------------------------------------------------------------

# Ensure critical variables are set first for CI and tests
export EDITOR="code --wait"
export PATH="$DOTFILES_DIR/scripts:$PATH"


# =================== ENVIRONMENT VARIABLES ===================
# Set the default text editor for command-line programs (e.g., git commit)
# Use "code --wait" for VS Code, or "vim", "nano", etc.
export EDITOR="code --wait"
# Set the default visual editor (used by some CLI tools)
export VISUAL="$EDITOR"
# Set the default pager for long output (e.g., man, git log)
export PAGER="less"
# Set language/locale for consistent UTF-8 support
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
# Add custom bin directories to PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$DOTFILES_DIR/scripts:$PATH"
# Add Homebrew to PATH if not already present (redundant with .zshenv, but safe)
if [ -f "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f "/usr/local/bin/brew" ]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi



# Enable a preview window for fzf's file finder (Ctrl+T)
# This will show the contents of the selected file using 'bat'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}'"


# Zsh options to improve workflow
setopt AUTO_CD              # Type a directory name to 'cd' into it
setopt NOTIFY               # Get a desktop notification for long-running commands
setopt EXTENDED_GLOB        # Enables more powerful file matching

# FZF Configuration
# In some environments (like Codespaces), the fzf plugin loads before the PATH is set.
# This explicitly tells the plugin where to find the fzf installation managed by Homebrew.
# FZF Configuration
# In some environments (like Codespaces), the fzf plugin loads before the PATH is set.
# This explicitly tells the plugin where to find the fzf installation managed by Homebrew.
if [ -d "$(brew --prefix fzf 2>/dev/null)" ]; then
  export FZF_BASE="$(brew --prefix fzf)"
fi

# --- 1Password CLI Integration ---
# Loads secrets from 1Password into the shell environment.
# Ensure you are logged in to 1Password CLI (op signin) for this to work.
load_1password_secrets() {
  if command -v op &> /dev/null; then
    # Example: Load a secret named "MY_API_KEY" from a vault item.
    # Replace "My Secret Item" and "API Key Field" with your actual item and field names.
    # export MY_API_KEY=$(op read "op://My Vault/My Secret Item/API Key Field" 2>/dev/null)
    # if [ -n "$MY_API_KEY" ]; then
    #   echo "1Password secret MY_API_KEY loaded."
    # fi

    # Add more secrets here as needed.
    : # No-op if no secrets are uncommented
  else
    echo "1Password CLI (op) not found. Skipping secret loading." >&2
  fi
}

# load_1password_secrets