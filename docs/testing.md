# Testing with Bats-Core

These dotfiles are set up with [Bats-Core](https://github.com/bats-core/bats-core), a TAP-compliant testing framework for Bash and Zsh scripts. This allows you to write automated tests for your shell functions and scripts, ensuring they behave as expected and preventing regressions.

## How it Works

1. **Bats-Core Installation:** The `install.sh` script (specifically, the `install_useful_tools` function in `lib/brew.sh`) will install `bats-core` via Homebrew.
2. **`tests` Directory:** All your test files (`.bats` extension) should reside in the `./tests/` directory.
3. **Test Execution:** You can run your tests using the `bats` command.

## Writing Tests

Bats-Core tests are written as shell scripts with a special syntax. Each test file should start with `#!/usr/bin/env bats`.

### Basic Test Structure

```bats
#!/usr/bin/env bats

@test "description of your test" {
  # Your test commands go here
  run your_command_or_function arg1 arg2

  # Assertions
  [ "$status" -eq 0 ] # Check exit status
  [ "$output" = "expected output" ] # Check standard output
  [ "$stderr" = "expected error output" ] # Check standard error
}
```

### Key Bats-Core Commands and Variables

* `@test "description" { ... }`: Defines a new test case.
* `run <command> [args...]`: Executes a command or function within the test environment. It captures `stdout`, `stderr`, and the `exit status`.
* `$status`: The exit status of the last `run` command.
* `$output`: The standard output of the last `run` command.
* `$stderr`: The standard error of the last `run` command.
* `[ <expression> ]`: Standard Bash conditional expressions for assertions.

### Sourcing Files in Tests

To test functions defined in your dotfiles (e.g., `mkcd` from `xdg/.config/zsh/functions/main-functions.zsh`), you need to `source` them within your test. Remember that Bats-Core runs each test in a subshell, so changes to environment variables or functions are isolated to that test.

```bats
#!/usr/bin/env bats

@test "my_function behaves correctly" {
  # Ensure DOTFILES_DIR is set for the test environment
  # This path is relative to the test file's location
  DOTFILES_DIR="$(cd "$(dirname "${BATS_TEST_DIRNAME}")/.." && pwd)"
  source "$DOTFILES_DIR/xdg/.config/zsh/functions/main-functions.zsh"

  run my_function "test_arg"
  [ "$status" -eq 0 ]
  [ "$output" = "expected result" ]
}
```

## Running Tests

Navigate to the root of your dotfiles repository and run the `bats` command, specifying the directory or individual test files:

```sh
bats tests/             # Run all tests in the 'tests' directory
bats tests/example.bats # Run a specific test file
```

## Example Test

See `tests/example.bats` for a practical example of testing a custom script and a Zsh function.
