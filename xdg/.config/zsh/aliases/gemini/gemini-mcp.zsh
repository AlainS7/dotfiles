# --------------------------------------------------------------------
# >> GEMINI MCP (Model Context Protocol) MANAGEMENT
# --------------------------------------------------------------------
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
