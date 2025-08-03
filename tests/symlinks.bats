#!/usr/bin/env bats

# Bats-Core test file for symlink checks in dotfiles
# Ensures that important symlinks exist and point to the correct files in the repo

setup() {
  # Set DOTFILES_DIR to the root of the dotfiles repo for use in tests
  export DOTFILES_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test ".zshrc symlink exists and points to repo file" {
  # Check that ~/.zshrc is a symlink to the repo's .zshrc
  [ -L "$HOME/.zshrc" ]
  [ "$(readlink "$HOME/.zshrc")" = "$DOTFILES_DIR/xdg/.config/zsh/.zshrc" ]
}

@test ".p10k.zsh symlink exists and points to repo file" {
  # Check that ~/.p10k.zsh is a symlink to the repo's .p10k.zsh
  [ -L "$HOME/.p10k.zsh" ]
  [ "$(readlink "$HOME/.p10k.zsh")" = "$DOTFILES_DIR/xdg/.config/zsh/.p10k.zsh" ]
}

@test ".zshenv symlink exists and points to repo file" {
  # Check that ~/.zshenv is a symlink to the repo's .zshenv
  [ -L "$HOME/.zshenv" ]
  [ "$(readlink "$HOME/.zshenv")" = "$DOTFILES_DIR/zsh/.zshenv" ]
}
