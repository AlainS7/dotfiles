#!/usr/bin/env bats

# Bats-Core test file for scripts in the dotfiles repo
# Tests script outputs, executability, and dry-run mode

setup() {
  # Set DOTFILES_DIR to the root of the dotfiles repo for use in tests
  export DOTFILES_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test "hello.sh script outputs expected greeting" {
  # Run hello.sh and check its output
  run "$DOTFILES_DIR/scripts/hello.sh"
  [ "$status" -eq 0 ]
  [ "$output" = "Hello from your custom scripts directory!" ]
}

@test "backup_dotfiles.sh is executable" {
  # Check that backup_dotfiles.sh is executable
  [ -x "$DOTFILES_DIR/scripts/backup_dotfiles.sh" ]
}

@test "all scripts in scripts/ are executable" {
  # Check that all .sh scripts in scripts/ are executable
  for script in "$DOTFILES_DIR/scripts/"*.sh; do
    [ -x "$script" ]
  done
}

@test "install.sh runs in dry-run mode" {
  # Run install.sh with --dry-run and check for expected output
  run bash "$DOTFILES_DIR/install.sh" --dry-run
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "Running in dry-run mode" || { echo 'install.sh did not run in dry-run mode.' >&2; exit 1; }
}
