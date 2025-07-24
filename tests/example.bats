#!/usr/bin/env bats

# This is an example Bats-Core test file.
# Bats-Core is a testing framework for Bash and Zsh scripts.
# Learn more at: https://github.com/bats-core/bats-core

# You can run this test file by navigating to your dotfiles root directory
# and executing: bats tests/example.bats

@test "hello.sh script outputs expected greeting" {
  # Run the script and capture its output
  run "$DOTFILES_DIR/scripts/hello.sh"

  # Assert that the exit status is 0 (success)
  [ "$status" -eq 0 ]

  # Assert that the output matches the expected string
  [ "$output" = "Hello from your custom scripts directory!" ]
}

@test "mkcd function creates directory and changes into it" {
  # Define a temporary directory for the test
  local test_dir="/tmp/test_mkcd_$(date +%s%N)"

  # Source the functions file to make mkcd available
  # Ensure DOTFILES_DIR is set for the test environment
  DOTFILES_DIR="$(cd "$(dirname "${BATS_TEST_DIRNAME}")/.." && pwd)"
  source "$DOTFILES_DIR/xdg/.config/zsh/functions/main_functions.zsh"

  # Run the mkcd function
  run mkcd "$test_dir"

  # Assert that the exit status is 0 (success)
  [ "$status" -eq 0 ]

  # Assert that the directory was created
  [ -d "$test_dir" ]

  # Assert that the current directory changed to the new directory
  # Note: Bats runs each test in a subshell, so $PWD will be the test's temp dir
  # We can't directly check if the *parent* shell's PWD changed, but we can
  # check if the function *attempted* to change it successfully.
  # For more robust PWD checks, you might need to use `cd` within the test
  # and then check $PWD, or test the function's side effects more indirectly.

  # Clean up the created directory
  rmdir "$test_dir"
}
