#!/usr/bin/env bash
# Git pre-commit and pre-push hook: Remind about sensitive info

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

cat <<EOF
${YELLOW}REMINDER: Before committing or pushing, double-check for any sensitive information (API keys, passwords, secrets, tokens, private data) in your changes!${NC}
EOF

# Continue with the commit/push
exit 0