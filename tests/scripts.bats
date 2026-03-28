#!/usr/bin/env bats

# Bats-Core test file for scripts in the dotfiles repo
# Tests script outputs, executability, and dry-run mode

setup() {
  # Set DOTFILES_DIR to the root of the dotfiles repo for use in tests
  export DOTFILES_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test "hello.sh script outputs expected greeting" {
  run "$DOTFILES_DIR/scripts/hello.sh"
  [ "$status" -eq 0 ]
  [ "$output" = "Hello from the custom scripts directory!" ]
}

@test "backup-dotfiles.sh is executable" {
  [ -x "$DOTFILES_DIR/scripts/backup-dotfiles.sh" ]
}

@test "uninstall.sh is executable" {
  [ -x "$DOTFILES_DIR/scripts/uninstall.sh" ]
}

@test "all scripts in scripts/ are executable" {
  for script in "$DOTFILES_DIR/scripts/"*.sh; do
    [ -x "$script" ]
  done
}

@test "install.sh runs in dry-run mode" {
  run zsh "$DOTFILES_DIR/install.sh" --dry-run
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "Running in dry-run mode" || { echo 'install.sh did not run in dry-run mode.' >&2; exit 1; }
}

@test "backup-dotfiles.sh uses set -euo pipefail" {
  head -5 "$DOTFILES_DIR/scripts/backup-dotfiles.sh" | grep -q "set -euo pipefail"
}

@test "backup-dotfiles.sh detects branch dynamically" {
  grep -q 'git rev-parse --abbrev-ref HEAD' "$DOTFILES_DIR/scripts/backup-dotfiles.sh"
}

@test "backup-dotfiles.sh uses git add -u (not git add .)" {
  grep -q 'git add -u' "$DOTFILES_DIR/scripts/backup-dotfiles.sh"
  ! grep -q 'git add \.' "$DOTFILES_DIR/scripts/backup-dotfiles.sh"
}
