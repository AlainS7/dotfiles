#!/usr/bin/env bats

# Bats-Core test file for shell aliases in dotfiles
# Tests that important aliases are defined as expected

setup() {
  # Set DOTFILES_DIR to the root of the dotfiles repo for use in tests
  export DOTFILES_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
}

@test "c alias is defined as clear" {
  source "$DOTFILES_DIR/xdg/.config/zsh/aliases/general-aliases.zsh"
  alias | grep -q "c='clear'" || { echo 'c alias is not defined as clear.' >&2; exit 1; }
}

@test "dotgit alias is set correctly" {
  source "$DOTFILES_DIR/xdg/.config/zsh/aliases/general-aliases.zsh"
  alias | grep -q "dotgit='/usr/bin/git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'" || { echo 'dotgit alias is not set correctly.' >&2; exit 1; }
}

@test "ll alias is defined" {
  source "$DOTFILES_DIR/xdg/.config/zsh/aliases/general-aliases.zsh"
  alias | grep -q "ll=" || { echo 'll alias is not defined.' >&2; exit 1; }
}

@test "la alias is defined" {
  source "$DOTFILES_DIR/xdg/.config/zsh/aliases/general-aliases.zsh"
  alias | grep -q "la=" || { echo 'la alias is not defined.' >&2; exit 1; }
}

@test "reload alias sources ~/.zshrc" {
  source "$DOTFILES_DIR/xdg/.config/zsh/aliases/general-aliases.zsh"
  alias | grep -q "reload='source ~/.zshrc'" || { echo 'reload alias not set correctly.' >&2; exit 1; }
}

@test "aliases alias points to correct file" {
  source "$DOTFILES_DIR/xdg/.config/zsh/aliases/general-aliases.zsh"
  alias | grep -q "general-aliases.zsh" || { echo 'aliases alias points to wrong file.' >&2; exit 1; }
}

@test "functions alias points to correct file" {
  source "$DOTFILES_DIR/xdg/.config/zsh/aliases/general-aliases.zsh"
  alias | grep -q "main-functions.zsh" || { echo 'functions alias points to wrong file.' >&2; exit 1; }
}

@test "safety aliases are defined (rm, cp, mv)" {
  source "$DOTFILES_DIR/xdg/.config/zsh/aliases/general-aliases.zsh"
  alias | grep -q "rm='rm -i'" || { echo 'rm safety alias not set.' >&2; exit 1; }
  alias | grep -q "cp='cp -i'" || { echo 'cp safety alias not set.' >&2; exit 1; }
  alias | grep -q "mv='mv -i'" || { echo 'mv safety alias not set.' >&2; exit 1; }
}

@test "git aliases are defined" {
  source "$DOTFILES_DIR/xdg/.config/zsh/aliases/general-aliases.zsh"
  alias | grep -q "gco=" || { echo 'gco alias not defined.' >&2; exit 1; }
  alias | grep -q "gb=" || { echo 'gb alias not defined.' >&2; exit 1; }
  alias | grep -q "gc=" || { echo 'gc alias not defined.' >&2; exit 1; }
}

@test "psguser is defined as a function" {
  source "$DOTFILES_DIR/xdg/.config/zsh/aliases/general-aliases.zsh"
  type psguser | grep -q "function" || { echo 'psguser should be a function.' >&2; exit 1; }
}
