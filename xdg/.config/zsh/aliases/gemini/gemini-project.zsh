# --------------------------------------------------------------------
# >> GEMINI PROJECT & LANGUAGE ALIASES
# --------------------------------------------------------------------
# Quick file analysis shortcuts
alias gmi-readme='gemini "@README.md Summarize this project"'
alias gmi-pkg='gemini "@package.json What does this project do and what are its dependencies?"'
alias gmi-gitignore='gemini "@.gitignore What files are being ignored and why?"'

# Project analysis workflows
alias gmi-review='gemini "@. Please review this codebase and provide feedback"'
alias gmi-docs='gemini "@. Generate documentation for this project"'
alias gmi-tests='gemini "@. Suggest test cases for this code"'

# Quick commands with common prompts
alias gmi-explain='gemini "Explain this in simple terms:"'
alias gmi-fix='gemini "Help me fix this error:"'
alias gmi-optimize='gemini "How can I optimize this code:"'
alias gmi-debug='gemini "Help me debug this issue:"'
alias gmi-learn='gemini "I want to learn about this topic. Please explain it step by step with examples:"'

# Language-specific aliases for targeted help
alias gmi-python='gemini "As a Python expert, help me with:"'
alias gmi-js='gemini "As a JavaScript expert, help me with:"'
alias gmi-ts='gemini "As a TypeScript expert, help me with:"'
alias gmi-react='gemini "As a React expert, help me with:"'
alias gmi-node='gemini "As a Node.js expert, help me with:"'
alias gmi-bash='gemini "As a Bash/shell scripting expert, help me with:"'
alias gmi-rust='gemini "As a Rust expert, help me with:"'
alias gmi-go='gemini "As a Go expert, help me with:"'
alias gmi-sql='gemini "As a SQL database expert, help me with:"'
alias gmi-docker='gemini "As a Docker expert, help me with:"'
alias gmi-git='gemini "As a Git expert, help me with:"'
alias gmi-css='gemini "As a CSS expert, help me with:"'

# Project-specific code analysis
# Python
# JS/Node
# React
# Each function checks for project files and provides feedback

gmi-py-project() {
    if [[ ! -f "requirements.txt" && ! -f "pyproject.toml" && ! -f "setup.py" ]]; then
        echo "[Warning] No Python project files found (requirements.txt, pyproject.toml, setup.py)"
    fi
    gemini "@. Analyze this Python project and provide insights about structure, dependencies, and best practices"
}

gmi-js-project() {
    if [[ ! -f "package.json" ]]; then
        echo "[Warning] No package.json found - may not be a JavaScript/Node.js project"
    fi
    gemini "@. Analyze this JavaScript/Node.js project and provide insights about structure, dependencies, and best practices"
}

gmi-react-project() {
    if [[ ! -f "package.json" ]] || ! grep -q "react" package.json 2>/dev/null; then
        echo "[Warning] No React dependencies found in package.json"
    fi
    gemini "@. Analyze this React project and provide insights about component structure, state management, and best practices"
}
