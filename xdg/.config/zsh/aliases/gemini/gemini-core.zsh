# --------------------------------------------------------------------
# >> MY CUSTOM GEMINI CLI ALIASES (Core)
# --------------------------------------------------------------------


# Basic Gemini CLI alias
alias gmi='gemini'

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
