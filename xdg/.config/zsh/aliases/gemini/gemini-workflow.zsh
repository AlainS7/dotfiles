# --------------------------------------------------------------------
# >> GEMINI WORKFLOW SHORTCUTS
# --------------------------------------------------------------------
# Workflow shortcuts (combine multiple operations) - with error handling

gmi-commit-help() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "[Error] Not in a git repository"
        return 1
    fi
    local staged_diff=$(git diff --cached)
    if [[ -z "$staged_diff" ]]; then
        echo "[Error] No staged changes found. Stage some changes first with 'git add'"
        return 1
    fi
    echo "$staged_diff" | gemini "Review this staged diff and suggest a good commit message with explanation"
}

gmi-error-help() {
    local last_error=$(tail -20 ~/.zsh_history 2>/dev/null | grep -E "(error|Error|ERROR)" | tail -1)
    if [[ -z "$last_error" ]]; then
        echo "[Error] No recent errors found in history"
        return 1
    fi
    gemini "Help me fix this error: $last_error"
}
