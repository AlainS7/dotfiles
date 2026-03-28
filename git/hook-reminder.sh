#!/usr/bin/env bash
# Git pre-commit and pre-push hook: Actively scan for sensitive data
# Bypass with: git commit --no-verify  /  git push --no-verify
set -e

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

# --- Secret Patterns ---
# Each pattern is a regex that might indicate leaked credentials.
SECRET_PATTERNS=(
  # API keys & tokens
  'PRIVATE[_-]?KEY'
  'API[_-]?KEY\s*[:=]'
  'API[_-]?SECRET\s*[:=]'
  'ACCESS[_-]?TOKEN\s*[:=]'
  'AUTH[_-]?TOKEN\s*[:=]'
  'SECRET[_-]?KEY\s*[:=]'
  # Specific provider patterns
  'sk-[A-Za-z0-9]{20,}'           # OpenAI / LiteLLM style
  'ntn_[A-Za-z0-9]{20,}'          # Notion API tokens
  'ghp_[A-Za-z0-9]{36}'           # GitHub personal access tokens
  'gho_[A-Za-z0-9]{36}'           # GitHub OAuth tokens
  'github_pat_[A-Za-z0-9_]{82}'   # GitHub fine-grained tokens
  'AKIA[0-9A-Z]{16}'              # AWS Access Key IDs
  'xox[bpas]-[A-Za-z0-9-]+'       # Slack tokens
  # Certificates & private keys
  'BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY'
  'BEGIN CERTIFICATE'
  # Generic password assignments
  '[Pp]assword\s*[:=]\s*["\x27][^"\x27]+'
  '[Ss]ecret\s*[:=]\s*["\x27][^"\x27]+'
  '[Tt]oken\s*[:=]\s*["\x27][^"\x27]+'
)

# --- Build combined regex ---
COMBINED_PATTERN=""
for pattern in "${SECRET_PATTERNS[@]}"; do
  if [ -z "$COMBINED_PATTERN" ]; then
    COMBINED_PATTERN="$pattern"
  else
    COMBINED_PATTERN="$COMBINED_PATTERN|$pattern"
  fi
done

# --- Scan staged diff ---
FOUND=0
if git rev-parse --verify HEAD >/dev/null 2>&1; then
  DIFF_TARGET="HEAD"
else
  # Initial commit — diff against empty tree
  DIFF_TARGET="$(git hash-object -t tree /dev/null)"
fi

# Search the staged diff (added lines only) for secret patterns
MATCHES=$(git diff --cached --diff-filter=ACMR -U0 "$DIFF_TARGET" | \
  grep -n -iE "^\+.*($COMBINED_PATTERN)" | \
  grep -v '^\+\+\+' || true)

if [ -n "$MATCHES" ]; then
  FOUND=1
  echo ""
  echo -e "${RED}[BLOCKED] Potential secrets detected in staged changes:${NC}"
  echo -e "${RED}───────────────────────────────────────────────────────${NC}"
  echo "$MATCHES" | head -20
  if [ "$(echo "$MATCHES" | wc -l)" -gt 20 ]; then
    echo -e "${YELLOW}  ... and more (truncated)${NC}"
  fi
  echo -e "${RED}───────────────────────────────────────────────────────${NC}"
  echo ""
  echo -e "${YELLOW}If these are false positives, bypass with:${NC}"
  echo -e "  git commit --no-verify"
  echo -e "  git push --no-verify"
  echo ""
fi

# --- Also check filenames for common secret files ---
SECRET_FILES=$(git diff --cached --name-only --diff-filter=ACR | \
  grep -iE '(\.env$|\.env\.local|\.pem$|\.key$|\.p12$|\.pfx$|id_rsa|id_ed25519|\.keystore$|credentials\.json$|service.account\.json$)' || true)

if [ -n "$SECRET_FILES" ]; then
  FOUND=1
  echo ""
  echo -e "${RED}[BLOCKED] Potentially sensitive files staged for commit:${NC}"
  echo "$SECRET_FILES" | while read -r f; do echo -e "  ${RED}• $f${NC}"; done
  echo ""
fi

if [ "$FOUND" -eq 1 ]; then
  exit 1
fi

# --- All clear ---
echo -e "${GREEN}[OK]${NC} No secrets detected in staged changes."
exit 0