
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
# Add TeX Live to PATH for LaTeX support
export PATH="/Library/TeX/texbin:$PATH"

# Android SDK setup
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/tools/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
# Add Homebrew to PATH if not already present (redundant with .zshenv, but safe)
if [ -f "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f "/usr/local/bin/brew" ]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi


# --- Local .env loader (optional) ---
# If a local env file exists at repo root, source it to populate secrets like LITELLM_API_KEY.
# Uses `set -a` to export vars defined within. Safe no-op if file not present.
if [ -n "$DOTFILES_DIR" ] && [ -f "$DOTFILES_DIR/.env.local" ]; then
  set -a
  . "$DOTFILES_DIR/.env.local"
  set +a
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
    # Configure the 1Password reference for LiteLLM in your shell profile or .zshenv, e.g.:
    # export OP_LITELLM_SECRET_PATH='op://My Vault/LiteLLM/API Key'
    local litellm_ref="${OP_LITELLM_SECRET_PATH:-}"

    # If neither var is set, attempt to read from 1Password
    if [ -z "${LITELLM_API_KEY:-}" ] && [ -z "${LITELLM_TOKEN:-}" ] && [ -n "$litellm_ref" ]; then
      local _litellm
      _litellm=$(op read --no-newline "$litellm_ref" 2>/dev/null)
      if [ -n "$_litellm" ]; then
        export LITELLM_API_KEY="$_litellm"
        export LITELLM_TOKEN="$_litellm"
        # echo "Loaded LiteLLM credentials from 1Password." >&2
      fi
    fi
    # Keep both env vars in sync if only one is present
    if [ -z "${LITELLM_API_KEY:-}" ] && [ -n "${LITELLM_TOKEN:-}" ]; then
      export LITELLM_API_KEY="$LITELLM_TOKEN"
    elif [ -z "${LITELLM_TOKEN:-}" ] && [ -n "${LITELLM_API_KEY:-}" ]; then
      export LITELLM_TOKEN="$LITELLM_API_KEY"
    fi
  else
    echo "1Password CLI (op) not found. Skipping secret loading." >&2
  fi
}

# load_1password_secrets
# Invoke the secret loader (safe no-op if not configured or 'op' not installed)
load_1password_secrets

# --- LiteLLM Configuration ---
# After attempting to load from 1Password, ensure variables are consistent.
# If only one of LITELLM_API_KEY / LITELLM_TOKEN is set, mirror it to the other.
if [ -z "${LITELLM_API_KEY:-}" ] && [ -n "${LITELLM_TOKEN:-}" ]; then
  export LITELLM_API_KEY="$LITELLM_TOKEN"
elif [ -z "${LITELLM_TOKEN:-}" ] && [ -n "${LITELLM_API_KEY:-}" ]; then
  export LITELLM_TOKEN="$LITELLM_API_KEY"
fi