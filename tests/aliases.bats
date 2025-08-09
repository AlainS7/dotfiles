#!/usr/bin/env bats

# Bats-Core test file for shell aliases in dotfiles
# Tests that important aliases are defined as expected

setup() {
  # Load the test helper
  load 'test_helper'
  # Set DOTFILES_DIR to the root of the dotfiles repo for use in tests
  export DOTFILES_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  # Create symlinks for the tests
  setup_symlinks_for_tests
}

@test "c alias is defined as clear" {
  # Source general-aliases.zsh and check that 'c' alias is set to 'clear'
  source "$DOTFILES_DIR/xdg/.config/zsh/aliases/general-aliases.zsh"
  alias | grep -q "c='clear'" || { echo 'c alias is not defined as clear.' >&2; exit 1; }
}

@test "dotgit alias is set correctly" {
  # Source general-aliases.zsh and check that 'dotgit' alias is set correctly
  source "$DOTFILES_DIR/xdg/.config/zsh/aliases/general-aliases.zsh"
  alias | grep -q "dotgit='/usr/bin/git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'" || { echo 'dotgit alias is not set correctly.' >&2; exit 1; }
}
