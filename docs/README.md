# Dotfiles Documentation

Welcome to the documentation for your dotfiles! This section provides detailed information about the various components of your dotfiles, how they work, and how you can customize them.

## Table of Contents

* [Dotpi companion repository (Codespaces)](#dotpi-companion-repository-codespaces)
* [Pi CLI on every Codespace](#pi-cli-on-every-codespace)
* [Custom Scripts](scripts.md)
* [Secrets Management](secrets.md)
* [Testing with Bats-Core](testing.md)

## Overview

Your dotfiles are designed to provide a robust, portable, and efficient development environment across macOS and Linux. They are managed via an automated installation script (`install.sh`) and are structured to be modular and easy to extend.

## Structure

```plaintext
.dotfiles/
├── docs/                 # This documentation
├── pi/                   # Pi CLI: codespaces-packages.txt (Codespaces-only installs)
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
* In **GitHub Codespaces**, install the [pi](https://pi.dev) CLI, optional lines from `pi/codespaces-packages.txt`, and **`pi install`** on each child of `~/.pi/extensions` after dotpi submodules sync (see [Pi CLI on every Codespace](#pi-cli-on-every-codespace)).

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
| `DOTPI_SHALLOW_CLONE` | *(unset)* | If `1`, uses `git clone --depth 1` **without** submodule recursion (submodules may be empty). Omit for `git clone --recurse-submodules` (recommended if dotpi uses submodule extension repos). |

If `$DOTPI_DIR/.git` already exists, the clone is skipped, but **`git submodule update --init --recursive`** still runs when `.gitmodules` is present so checked-in extension submodules populate.

### GitHub Codespaces dotfiles

This repo can be used as your [personal dotfiles repository for Codespaces](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/personalizing-github-codespaces-for-your-account). Optional `.codespaces/dotfiles.json` in this repo can set `"shell": "zsh"` (or an explicit `"installCommand"` if you prefer).

## Pi CLI on every Codespace

GitHub only runs your **personal dotfiles** install on every codespace, not each repository’s `.devcontainer`. To get [`pi`](https://pi.dev) (and pi “extensions” / packages) on **every** codespace, use this repo’s `install.sh`: it runs `setup_pi_for_codespaces` when the same [Codespace-only guards](#dotpi-companion-repository-codespaces) apply (Linux, `CODESPACES=true`, `CODESPACE_NAME` set). Set **`PI_SKIP=1`** to disable.

What it does:

1. Ensures **npm** exists (`brew install node` on the codespace if `npm` is missing).
2. Runs **`npm install -g @mariozechner/pi-coding-agent`** if `pi` is not already on `PATH`.
3. Appends npm’s global **`bin`** directory to **`~/.zprofile`** once so new shells find `pi`.
4. For each non-comment line in **`pi/codespaces-packages.txt`** (optional file), runs **`pi install`** with that line as the package spec (see [pi packages](https://pi.dev/docs/latest/packages), e.g. `npm:@scope/package` or `git:github.com/user/repo@v1`).
5. For each **immediate subdirectory** of **`DOTPI_EXTENSION_ROOT`** (default **`~/.pi/extensions`**) that looks like a pi package (has `package.json` and/or `extensions/`, `skills/`, `prompts/`, or `themes/`), runs **`npm install`** in that folder when `package.json` exists, then **`pi install /absolute/path/to/that/folder`**.

There is **no `pi add .`** for packages: [pi.dev](https://pi.dev/docs/latest/packages) registers local trees with **`pi install /path`** or **`pi install ./relative/path`**. Submodule repos under `~/.pi/extensions/foo` are normal directories on disk after **`git submodule update --init --recursive`**; the installer does that for dotpi, then runs **`pi install`** on each qualifying child directory—no manual `cd` into each repo required.

**See what is already installed:** run **`pi list`** (reads global settings, same file the installer logs). That is the supported way to inspect registered npm/git/local packages—not `npm list -g` alone, because pi records sources in **`~/.pi/agent/settings.json`**.

| Variable | Default | Purpose |
| --- | --- | --- |
| `DOTPI_EXTENSION_ROOT` | `$HOME/.pi/extensions` | Parent directory whose **child** folders get `pi install` |
| `PI_SKIP_DOTPI_EXTENSIONS` | *(unset)* | If set, skip step 5 (dotpi extension dirs only) |

Edit `pi/codespaces-packages.txt` in this dotfiles repo, commit, and rebuild or recreate the codespace so dotfiles re-run.

**Not project-specific:** keep the list in **dotfiles**; do not duplicate in each repo’s `devcontainer.json` unless you need a one-off override.

**Same spoofing caveat** as the dotpi section: env-based detection is for convenience, not proof of GitHub’s cloud.
