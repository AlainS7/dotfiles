# --------------------------------------------------------------------
# >> MY CUSTOM GEMINI CLI ALIASES
# --------------------------------------------------------------------
# 
# Gemini CLI supports several built-in commands:
# - Slash commands (/): Meta-level control (/help, /clear, /quit, /stats, etc.)
# - At commands (@): Include file/directory content (@file.txt, @src/, etc.)
# - Shell commands (!): Execute shell commands (!ls, !git status, etc.)
# 
# For full documentation of built-in commands, see:
# https://ai.google.dev/gemini-api/docs/cli/commands
# --------------------------------------------------------------------

# Basic Gemini CLI alias
alias gmi="gemini"

# Quick help and info commands
alias gmi-help='gemini --help'
alias gmi-about='echo "Type /about in Gemini CLI for version info"'

# Session management
alias gmi-stats='echo "Type /stats in Gemini CLI for session statistics"'
alias gmi-clear='echo "Type /clear or Ctrl+L in Gemini CLI to clear screen"'

# File and directory analysis (using @ commands)
alias gmi-file='echo "Usage: gemini then type @path/to/file.txt followed by your question"'
alias gmi-dir='echo "Usage: gemini then type @path/to/directory/ followed by your question"'

# Memory and context management
alias gmi-memory='echo "Type /memory show|add|refresh in Gemini CLI to manage context"'
alias gmi-compress='echo "Type /compress in Gemini CLI to summarize chat context"'

# Chat state management
alias gmi-save-chat='echo "Type /chat save <tag> in Gemini CLI to save conversation"'
alias gmi-resume-chat='echo "Type /chat resume <tag> in Gemini CLI to resume conversation"'
alias gmi-list-chats='echo "Type /chat list in Gemini CLI to list saved conversations"'

# Tools and MCP
alias gmi-tools='echo "Type /tools in Gemini CLI to list available tools"'
alias gmi-mcp='echo "Type /mcp in Gemini CLI to list Model Context Protocol servers"'

# Shell integration
alias gmi-shell='echo "Type ! in Gemini CLI to toggle shell mode, or !command to run once"'

# Output management
alias gmi-clip='gemini "$@" | pbcopy && echo "[Gemini output copied to clipboard]"'
alias gmi-save='gemini "$@" > gemini_output_$(date +%Y%m%d_%H%M%S).txt && echo "[Output saved with timestamp]"'
alias gmi-log='mkdir -p ~/gemini_logs && gemini "$@" | tee ~/gemini_logs/session_$(date +%Y%m%d_%H%M%S).log'

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

# Add more custom Gemini CLI aliases below as needed

# ============================================================================
# MCP (Model Context Protocol) Server Management
# ============================================================================
# MCP servers extend Gemini CLI with additional tools and capabilities
# Popular servers: filesystem, git, github, sqlite, fetch, memory, etc.

# MCP server installation helpers
gmi-install-mcp() {
    echo "Installing essential MCP servers..."
    echo "This will install the most useful MCP servers globally via npm"
    echo ""
    
    local servers=(
        "@modelcontextprotocol/server-filesystem"  # File operations
        "@modelcontextprotocol/server-git"         # Git operations
        "@modelcontextprotocol/server-fetch"       # HTTP requests
        "@modelcontextprotocol/server-sqlite"      # SQLite database
        "@modelcontextprotocol/server-memory"      # Persistent memory
        "@modelcontextprotocol/server-brave-search" # Web search
    )
    
    for server in "${servers[@]}"; do
        echo "Installing $server..."
        npm install -g "$server" 2>/dev/null && echo "✓ $server installed" || echo "✗ Failed to install $server"
    done
    
    echo ""
    echo "Installation complete! Run 'gmi-setup-mcp' to configure them."
}

# MCP server configuration setup
gmi-setup-mcp() {
    local config_dir="$HOME/.config/gemini"
    local mcp_config="$config_dir/mcp_servers.json"
    
    mkdir -p "$config_dir"
    
    if [[ -f "$mcp_config" ]]; then
        echo "[Warning] MCP config already exists at $mcp_config"
        echo "Backup created at ${mcp_config}.backup"
        cp "$mcp_config" "${mcp_config}.backup"
    fi
    
    cat > "$mcp_config" <<'EOF'
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-filesystem", "/tmp"]
    },
    "git": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-git", "--repository", "."]
    },
    "fetch": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-fetch"]
    },
    "sqlite": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-sqlite", "--db-path", "./database.sqlite"]
    },
    "memory": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-memory"]
    },
    "search": {
      "command": "npx",
      "args": ["@modelcontextprotocol/server-brave-search"]
    }
  }
}
EOF
    
    echo "[Gemini] MCP servers configured at $mcp_config"
    echo "Available servers: filesystem, git, fetch, sqlite, memory, search"
    echo "Run 'gemini' and use '/mcp' to see server status"
}

# MCP server information and usage
gmi-mcp-info() {
    cat <<'EOF'
🔧 MCP Server Capabilities:

📁 FILESYSTEM - File and directory operations
   • Read/write files, create directories, file search
   • Usage: Ask Gemini to "read the file X" or "create directory Y"

🔀 GIT - Git repository management  
   • Commit, branch, status, diff, log operations
   • Usage: "Show me the git status" or "create a new branch"

🌐 FETCH - HTTP requests and API calls
   • GET/POST requests, API integration, web scraping
   • Usage: "Fetch data from this API endpoint"

🗄️ SQLITE - SQLite database operations
   • Query, insert, update, create tables
   • Usage: "Query the database for..." or "Create a table..."

🧠 MEMORY - Persistent memory across sessions
   • Remember information between conversations
   • Usage: "Remember that I prefer TypeScript" 

🔍 SEARCH - Web search capabilities
   • Search the web for current information
   • Usage: "Search for the latest info about..."

📋 Commands:
   • gmi-install-mcp   - Install all essential MCP servers
   • gmi-setup-mcp     - Configure MCP servers for Gemini
   • /mcp              - (In Gemini) Show server status
   • /tools            - (In Gemini) List available tools
EOF
}

# Quick MCP aliases
alias gmi-mcp-status='echo "Run gemini and type /mcp to see server status"'
alias gmi-mcp-tools='echo "Run gemini and type /tools to see available tools"'



# ============================================================================
# End of custom Gemini CLI aliases
# ============================================================================