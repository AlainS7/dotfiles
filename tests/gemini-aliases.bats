#!/usr/bin/env bats

# Test that the 'gmi' and 'gemini' aliases are available and functional

setup() {
  # Source the main gemini alias loader (adjust path if needed)
  source "$BATS_TEST_DIRNAME/../xdg/.config/zsh/aliases/gemini/gemini.zsh"
}

@test "gmi alias is defined after sourcing gemini.zsh (non-interactive)" {
  loader="$BATS_TEST_DIRNAME/../xdg/.config/zsh/aliases/gemini/gemini.zsh"
  run zsh -c "source '$loader'; alias gmi"
  [ "$status" -eq 0 ]
  [[ "$output" == *"gmi=gemini"* ]]
}

@test "gemini command is available in PATH" {
  run which gemini
  [ "$status" -eq 0 ]
}
