@test "gmi alias is defined after sourcing gemini.zsh (non-interactive)" {
  loader="$BATS_TEST_DIRNAME/../xdg/.config/zsh/aliases/gemini/gemini.zsh"
  run zsh -c "source '$loader'; alias gmi"
  [ "$status" -eq 0 ]
  [[ "$output" == *"alias gmi='gemini'"* ]]
}
#!/usr/bin/env bats

# Test that the 'gmi' and 'gemini' aliases are available and functional

setup() {
  # Source the main gemini alias loader (adjust path if needed)
  source "$BATS_TEST_DIRNAME/../xdg/.config/zsh/aliases/gemini/gemini.zsh"
}

@test "debug: show all aliases after sourcing gemini.zsh" {
  loader="$BATS_TEST_DIRNAME/../xdg/.config/zsh/aliases/gemini/gemini.zsh"
  echo "[BATS DEBUG] loader path: $loader" > "$BATS_TEST_DIRNAME/../debug_output.txt"
  zsh -i -c "source '$loader'; alias" >> "$BATS_TEST_DIRNAME/../debug_output.txt"
  cat "$BATS_TEST_DIRNAME/../debug_output.txt"
}

@test "gemini command is available in PATH" {
  run which gemini
  [ "$status" -eq 0 ]
}
