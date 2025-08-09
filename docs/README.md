# Dotfiles Documentation

Welcome to the documentation for your dotfiles! This section provides detailed information about the various components of your dotfiles, how they work, and how you can customize them.

## Table of Contents

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
│   └── Brewfile          # Homebrew packages
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
* Install all dependencies from the `lib/Brewfile` using `brew bundle`.
* Install Oh My Zsh and Powerlevel10k.
* Install Zsh plugins (autosuggestions, syntax-highlighting).
* Set up symbolic links for your configuration files.
* Configure Git global settings.
* Apply macOS-specific defaults (if on macOS).
* Create a `~/.zshrc.local` file from the template for machine-specific settings.

After installation, restart your terminal or log out and back in for all changes to take effect.
