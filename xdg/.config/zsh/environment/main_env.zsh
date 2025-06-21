# --------------------------------------------------------------------
# >> ENVIRONMENT VARIABLES & SHELL OPTIONS
# --------------------------------------------------------------------

# Set the default text editor for command-line programs (e.g., git commit)
# Use "code --wait" for VS Code, or "vim", "nano", etc.
export EDITOR="code --wait"

# Add a directory for personal scripts to my command path
# Allows running any script placed in ~/.local/bin from anywhere
mkdir -p ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"

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
if [ -d "$(brew --prefix fzf 2>/dev/null)" ]; then
  export FZF_BASE="$(brew --prefix fzf)"
fi