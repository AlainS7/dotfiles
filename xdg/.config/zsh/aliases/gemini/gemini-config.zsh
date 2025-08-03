# --------------------------------------------------------------------
# >> GEMINI CONFIGURATION & CUSTOMIZATION
# --------------------------------------------------------------------
# Configuration management
gmi-config() {
    local config_dir="$HOME/.config/gemini"
    mkdir -p "$config_dir"
    if [[ ! -f "$config_dir/settings.json" ]]; then
        cat > "$config_dir/settings.json" <<EOF
{
  "theme": "dark",
  "fileFiltering": {
    "respectGitignore": true,
    "excludePatterns": [".env*", "*.log", "node_modules/**", "dist/**", ".git/**"]
  },
  "checkpointing": true,
  "verbose": false
}
EOF
        echo "[Gemini] Created default config at $config_dir/settings.json"
    else
        echo "[Gemini] Config already exists at $config_dir/settings.json"
    fi
}

# Configuration and customization
alias gmi-theme='echo "Type /theme in Gemini CLI to change visual theme"'
alias gmi-editor='echo "Type /editor in Gemini CLI to select preferred editor"'
alias gmi-auth='echo "Type /auth in Gemini CLI to change authentication method"'

# Debugging and development
alias gmi-bug='echo "Type /bug <description> in Gemini CLI to file an issue"'
alias gmi-restore='echo "Type /restore [tool_call_id] in Gemini CLI to undo tool changes"'

# Advanced usage examples
alias gmi-checkpointing='gemini --checkpointing'
alias gmi-verbose='gemini --verbose'
