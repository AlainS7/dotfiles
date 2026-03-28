#!/usr/bin/env bats

# Bats-Core test file for security checks
# Ensures secrets are not committed and the hook scanner works

setup() {
  export DOTFILES_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test ".env.local is listed in .gitignore" {
  grep -q '\.env\.local' "$DOTFILES_DIR/.gitignore"
}

@test ".env.local is not tracked by git" {
  cd "$DOTFILES_DIR"
  # git ls-files should return empty for .env.local (not tracked)
  result=$(git ls-files .env.local)
  [ -z "$result" ]
}

@test "no tracked files contain API key patterns" {
  cd "$DOTFILES_DIR"
  # Search tracked files for common secret patterns
  # Exclude .bats test files and hook-reminder.sh (which contains the patterns as scan targets)
  run bash -c "git ls-files | grep -v '\.bats$' | grep -v 'hook-reminder.sh' | grep -v '\.gitignore' | xargs grep -l -iE '(sk-[A-Za-z0-9]{20,}|ntn_[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{36})' 2>/dev/null || true"
  [ -z "$output" ]
}

@test "hook-reminder.sh exists and is executable" {
  [ -f "$DOTFILES_DIR/git/hook-reminder.sh" ]
  [ -x "$DOTFILES_DIR/git/hook-reminder.sh" ]
}

@test "hook-reminder.sh scans for secret patterns" {
  # Verify the hook contains active scanning logic (not just a passive reminder)
  grep -q 'SECRET_PATTERNS' "$DOTFILES_DIR/git/hook-reminder.sh"
  grep -q 'git diff --cached' "$DOTFILES_DIR/git/hook-reminder.sh"
}

@test "global gitignore file exists" {
  [ -f "$DOTFILES_DIR/git/.gitignore" ]
}

@test "global gitignore blocks .env files" {
  grep -q '\.env' "$DOTFILES_DIR/git/.gitignore"
}

@test "global gitignore blocks private keys" {
  grep -q 'pem' "$DOTFILES_DIR/git/.gitignore"
  grep -q 'key' "$DOTFILES_DIR/git/.gitignore"
}

@test "OP_LITELLM_SECRET_PATH is not hardcoded in tracked zshenv" {
  # The 1Password vault reference should not be in tracked files
  ! grep -q "^export OP_LITELLM_SECRET_PATH=" "$DOTFILES_DIR/zsh/.zshenv"
}
