#!/usr/bin/env bats

# Bats-Core test file for environment variable setup in dotfiles
# Tests that key environment variables are set as expected by your configuration

setup() {
  # Set DOTFILES_DIR to the root of the dotfiles repo for use in tests
  export DOTFILES_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test "EDITOR environment variable is set to code --wait" {
  # Source the main-env.zsh and check that EDITOR is set correctly
  run zsh -c "source '$DOTFILES_DIR/xdg/.config/zsh/environment/main-env.zsh'; echo $EDITOR"
  [ "$status" -eq 0 ]
  [ "$output" = "code --wait" ]
}

@test "PATH includes dotfiles scripts and local bin" {
  # Source the main-env.zsh and check that PATH includes expected directories
  run zsh -c "source '$DOTFILES_DIR/xdg/.config/zsh/environment/main-env.zsh'; echo $PATH"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "$HOME/.local/bin" || { echo 'PATH does not include $HOME/.local/bin' >&2; exit 1; }
  echo "$output" | grep -q "$DOTFILES_DIR/scripts" || { echo 'PATH does not include $DOTFILES_DIR/scripts' >&2; exit 1; }
}
