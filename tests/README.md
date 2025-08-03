# Dotfiles Test Suite

This repository uses [Bats-Core](https://github.com/bats-core/bats-core) for automated testing of scripts, functions, and configuration. This ensures your dotfiles remain robust and portable across environments.

## Running the Tests

From the root of your dotfiles repository, run:

```sh
bats tests/
```

## What is Tested?

- Script output and exit codes
- Custom functions and aliases
- Environment variables
- Symlink correctness
- Script executability
- Install script dry-run

## Adding More Tests

- Add new `.bats` files in the `tests/` directory for new features or scripts.
- Follow the examples in `simple.bats` for structure and style.

## Continuous Integration (CI)

This repo includes a GitHub Actions workflow to run all Bats tests on every push and pull request. See `.github/workflows/bats.yml`.

---

For more info, see the comments in your test files and the [Bats-Core documentation](https://github.com/bats-core/bats-core).
