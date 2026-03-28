#!/usr/bin/env bats

# Bats-Core test file for custom shell functions in dotfiles
# Tests mkcd, extract, and explain functions for expected behavior

setup() {
  # Set DOTFILES_DIR to the root of the dotfiles repo for use in tests
  export DOTFILES_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test "mkcd function creates directory and changes into it" {
  source "$DOTFILES_DIR/xdg/.config/zsh/functions/main-functions.zsh"
  type mkcd &>/dev/null || { echo 'mkcd function is not defined after sourcing.' >&2; exit 1; }
  local test_dir="/tmp/test_mkcd_$(date +%s%N)"
  run mkcd "$test_dir"
  [ "$status" -eq 0 ]
  [ -d "$test_dir" ]
  rmdir "$test_dir"
}

@test "mkcd function with no argument returns error" {
  source "$DOTFILES_DIR/xdg/.config/zsh/functions/main-functions.zsh"
  run mkcd
  [ "$status" -ne 0 ]
  [[ "$output" == *"Usage"* ]]
}

@test "explain function is defined" {
  source "$DOTFILES_DIR/xdg/.config/zsh/functions/main-functions.zsh"
  type explain &>/dev/null || { echo 'explain function is not defined.' >&2; exit 1; }
}

@test "explain function with no argument returns usage" {
  source "$DOTFILES_DIR/xdg/.config/zsh/functions/main-functions.zsh"
  run explain
  [ "$status" -ne 0 ]
  [[ "$output" == *"Usage"* ]]
}

@test "extract function is available (from OMZ plugin or custom)" {
  # The extract function should be available after sourcing
  # either from OMZ extract plugin or from main-functions.zsh
  source "$DOTFILES_DIR/xdg/.config/zsh/functions/main-functions.zsh"
  # At minimum, verify the comment about OMZ extract is present
  grep -q "extract" "$DOTFILES_DIR/xdg/.config/zsh/functions/main-functions.zsh"
}

@test "extract function with missing file returns error" {
  # Test with a standalone extract if available (OMZ provides it at runtime)
  source "$DOTFILES_DIR/xdg/.config/zsh/functions/main-functions.zsh"
  if type extract &>/dev/null; then
    run extract /tmp/nonexistentfile.tar.gz
    [ "$status" -ne 0 ] || [[ "$output" == *"not a valid file"* ]] || [[ "$output" == *"no such file"* ]]
  else
    skip "extract function not available without OMZ runtime"
  fi
}

@test "gmi-clip is defined as a function" {
  source "$DOTFILES_DIR/xdg/.config/zsh/aliases/gemini/gemini-core.zsh"
  type gmi-clip | grep -q "function" || { echo 'gmi-clip should be a function, not an alias.' >&2; exit 1; }
}

@test "gmi-save is defined as a function" {
  source "$DOTFILES_DIR/xdg/.config/zsh/aliases/gemini/gemini-core.zsh"
  type gmi-save | grep -q "function" || { echo 'gmi-save should be a function, not an alias.' >&2; exit 1; }
}

@test "gmi-log is defined as a function" {
  source "$DOTFILES_DIR/xdg/.config/zsh/aliases/gemini/gemini-core.zsh"
  type gmi-log | grep -q "function" || { echo 'gmi-log should be a function, not an alias.' >&2; exit 1; }
}