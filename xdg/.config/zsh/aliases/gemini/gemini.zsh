# --------------------------------------------------------------------
# >> MY CUSTOM GEMINI CLI ALIASES (Modular Loader)
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


# Robust path resolution for both Bash and Zsh, interactive and non-interactive
if [ -n "$ZSH_VERSION" ]; then
  _gemini_alias_dir="$(cd "$(dirname -- ${0:A})" && pwd)"
elif [ -n "$BASH_VERSION" ]; then
  _gemini_alias_dir="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
else
  _gemini_alias_dir="$(cd "$(dirname -- "$0")" && pwd)"
fi

source "$_gemini_alias_dir/gemini-core.zsh"
source "$_gemini_alias_dir/gemini-project.zsh"
source "$_gemini_alias_dir/gemini-config.zsh"
source "$_gemini_alias_dir/gemini-workflow.zsh"
source "$_gemini_alias_dir/gemini-mcp.zsh"
