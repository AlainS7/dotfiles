# Dotfiles Documentation

Welcome to the documentation for your dotfiles! This section provides detailed information about the various components of your dotfiles, how they work, and how you can customize them.

## Table of Contents

* [Dotpi companion repository (Codespaces)](#dotpi-companion-repository-codespaces)
* [Custom Scripts](scripts.md)
* [Secrets Management](secrets.md)
* [Testing with Bats-Core](testing.md)

## Overview

Your dotfiles are designed to provide a robust, portable, and efficient development environment across macOS and Linux. They are managed via an automated installation script (`install.sh`) and are structured to be modular and easy to extend.

## Structure

```plaintext
.dotfiles/
├── docs/                 # This documentation
├── git/                  # Git configurations and hooks
├── lib/                  # Helper scripts for installation
├── scripts/              # Your custom shell scripts
├── tests/                # Bats-Core tests for your scripts
├── xdg/                  # XDG Base Directory Specification compliant configs
│   └── .config/
│       └── zsh/
│           ├── aliases/      # Custom Zsh aliases
│           ├── environment/  # Custom Zsh environment variables
│           ├── functions/    # Custom Zsh functions
│           ├── .p10k.zsh     # Powerlevel10k configuration
│           └── .zshrc        # Main Zsh configuration (sourced by .zshenv)
├── zsh/                  # Zsh-related files (minimal, includes .zshenv)
│   ├── .zshenv           # Essential Zsh environment variables (sourced first)
│   └── .zshrc.local.example  # Template for machine-specific Zsh settings
├── .bashrc               # Bash fallback/autolauncher
├── .gitignore            # Git ignore rules for this repository
└── install.sh            # Main installation script
```

## Getting Started

If you haven't already, clone this repository and run the `install.sh` script:

```sh
git clone https://github.com/AlainS7/dotfiles.git
cd dotfiles
./install.sh
```

This script will:

* Install Homebrew (if not present).
* Install essential command-line tools (fzf, bat, eza, etc.) via Homebrew.
* Install Oh My Zsh and Powerlevel10k.
* Install Zsh plugins (autosuggestions, syntax-highlighting).
* Set up symbolic links for your configuration files.
* Configure Git global settings.
* Apply macOS-specific defaults (if on macOS).
* Create a `~/.zshrc.local` file from the template for machine-specific settings.
* In **GitHub Codespaces**, clone the separate [dotpi](https://github.com/AlainS7/dotpi-remote) repo into `~/.pi` (see [Dotpi companion repository](#dotpi-companion-repository-codespaces)).

After installation, restart your terminal or log out and back in for all changes to take effect.

## Dotpi companion repository (Codespaces)

The [dotpi](https://github.com/AlainS7/dotpi-remote) repository is not part of this dotfiles repo. During `install.sh`, a post-setup step (`setup_dotpi_for_codespaces`) may clone it.

### When it runs

Cloning happens only when the following are true:

1. **GitHub Codespaces** — `CODESPACES` is exactly `true` and `CODESPACE_NAME` is set (GitHub’s default codespace environment variables).
2. **Not macOS** — `uname` is not `Darwin` (dotpi automation is intentionally skipped on Mac).
3. **`DOTPI_SKIP` is unset** — set `DOTPI_SKIP=1` in the environment before install to disable this step entirely.

The main installer still **exits on Windows** (macOS/Linux only), so this path never runs on Windows.

> **Warning: checks are not tamper-proof.** The installer only reads the process environment and `uname`. Anything that can set env vars before `install.sh` runs can circumvent the intended “Codespaces only” behavior, for example:
>
> - Exporting `CODESPACES=true` and `CODESPACE_NAME=anything` in `~/.profile`, CI, or a wrapper script.
> - Running install inside a **Linux VM or container** on a Mac (so `uname` is Linux while you are still on local hardware).
> - Patching the script or running a modified copy.
>
> This is not cryptographic proof that GitHub created the machine. It blocks casual mistakes and “wrong OS” cases; it does **not** stop a determined actor who controls the environment. Set `DOTPI_SKIP=1` if unsure.

### Clone location and overrides

| Variable | Default | Purpose |
| --- | --- | --- |
| `DOTPI_DIR` | `$HOME/.pi` | Directory to clone into |
| `DOTPI_REPO_URL` | `https://github.com/AlainS7/dotpi-remote.git` | Git remote URL |
| `DOTPI_SKIP` | *(unset)* | If set to any value, skip cloning |

If `$DOTPI_DIR/.git` already exists, the step is skipped (idempotent).

### GitHub Codespaces dotfiles

This repo can be used as your [personal dotfiles repository for Codespaces](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/personalizing-github-codespaces-for-your-account). Optional `.codespaces/dotfiles.json` in this repo can set `"shell": "zsh"` (or an explicit `"installCommand"` if you prefer).
