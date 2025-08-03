# Negative test: mkcd with no argument
@test "mkcd function with no argument returns error" {
  source "$DOTFILES_DIR/xdg/.config/zsh/functions/main-functions.zsh"
  run mkcd
  [ "$status" -ne 0 ]
}

# Negative test: extract with missing file
@test "extract function with missing file returns error" {
  source "$DOTFILES_DIR/xdg/.config/zsh/functions/main-functions.zsh"
  run extract /tmp/nonexistentfile.tar.gz
  [ "$status" -eq 0 ]
  [[ "$output" == *"is not a valid file"* ]]
}
#!/usr/bin/env bats

# Bats-Core test file for custom shell functions in dotfiles
# Tests mkcd and extract functions for expected behavior

setup() {
  # Set DOTFILES_DIR to the root of the dotfiles repo for use in tests
  export DOTFILES_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test "mkcd function creates directory and changes into it" {
  # Source the main-functions.zsh to make mkcd available
  source "$DOTFILES_DIR/xdg/.config/zsh/functions/main-functions.zsh"
  type mkcd &>/dev/null || { echo 'mkcd function is not defined after sourcing.' >&2; exit 1; }
  local test_dir="/tmp/test_mkcd_$(date +%s%N)"
  # Run mkcd and check directory creation
  run mkcd "$test_dir"
  [ "$status" -eq 0 ]
  [ -d "$test_dir" ]
  # Clean up
  rmdir "$test_dir"
}

@test "extract function extracts tar.bz2 archive" {
  # Source the main-functions.zsh to make extract available
  source "$DOTFILES_DIR/xdg/.config/zsh/functions/main-functions.zsh"
  type extract &>/dev/null || { echo 'extract function is not defined after sourcing.' >&2; exit 1; }
  local test_file="/tmp/testfile.txt"
  local archive="/tmp/testarchive.tar.bz2"
  echo "test content" > "$test_file"
  tar cjf "$archive" -C /tmp testfile.txt
  # Run extract and check extraction
  run extract "$archive"
  [ "$status" -eq 0 ]
  [ -f "/tmp/testfile.txt" ]
  # Clean up
  rm -f "$archive" "/tmp/testfile.txt"
}
