# --------------------------------------------------------------------
# >> ENVIRONMENT VARIABLES & SHELL OPTIONS
# --------------------------------------------------------------------

# Set the default text editor for command-line programs (e.g., git commit)
# Use "code --wait" for VS Code, or "vim", "nano", etc.
export EDITOR="code --wait"

# Add a directory for your own personal scripts to your command path
# This allows you to run any script you place in ~/.local/bin from anywhere
mkdir -p ~/.local/bin
export PATH="$HOME/.local/bin:$PATH"

# Enable a preview window for fzf's file finder (Ctrl+T)
# This will show you the contents of the selected file using 'bat'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}'"


# Zsh options to improve your workflow
setopt AUTO_CD              # Type a directory name to 'cd' into it
setopt NOTIFY               # Get a desktop notification for long-running commands
setopt EXTENDED_GLOB        # Enables more powerful file matching