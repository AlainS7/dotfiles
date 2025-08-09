#!/usr/bin/env bats

# Test that the 'gmi' and 'gemini' aliases are available and functional

setup() {
  # Load the test helper
  load 'test_helper'
  # Set DOTFILES_DIR to the root of the dotfiles repo for use in tests
  export DOTFILES_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  # Create symlinks for the tests
  setup_symlinks_for_tests
  # Install Oh My Zsh for the tests
  install_oh_my_zsh_for_tests
}

@test "gmi alias is defined after sourcing gemini.zsh (non-interactive)" {
  run zsh -ic "alias gmi"
  [ "$status" -eq 0 ]
  [[ "$output" == *"gmi=gemini"* ]]
}
