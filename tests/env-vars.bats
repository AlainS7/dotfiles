#!/usr/bin/env bats

# Bats-Core test file for checking DOTFILES_DIR environment variable
# Ensures DOTFILES_DIR is set and points to a valid directory

setup() {
  # Set DOTFILES_DIR to the root of the dotfiles repo for use in tests
  export DOTFILES_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test "DOTFILES_DIR is set and points to a directory" {
  # Check that DOTFILES_DIR is non-empty and is a directory
  [ -n "$DOTFILES_DIR" ]
  [ -d "$DOTFILES_DIR" ]
}
