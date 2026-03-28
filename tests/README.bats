#!/usr/bin/env bats

# Bats-Core test file for README.md content validation
# Ensures the README contains essential sections

setup() {
  export DOTFILES_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  export README="$DOTFILES_DIR/README.md"
}

@test "README.md exists" {
  [ -f "$README" ]
}

@test "README.md contains Features section" {
  grep -qi "features" "$README"
}

@test "README.md contains Installation section" {
  grep -qi "installation" "$README"
}

@test "README.md contains Customization section" {
  grep -qi "customization" "$README"
}

@test "README.md references install.sh" {
  grep -q "install.sh" "$README"
}

@test "README.md mentions testing" {
  grep -qi "test" "$README"
}
