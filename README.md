# My Dotfiles

This repository contains my personal dotfiles for macOS and Linux. The setup is automated via an installation script that handles everything from package installation to configuration symlinking.

## Features

- **Automated Installation:** The `install.sh` script automates the entire setup process.
- **Cross-Platform Compatibility:** The dotfiles are designed to work on both macOS and Linux.
- **Homebrew-based:** Homebrew is used to manage packages, ensuring consistency across platforms.
- **XDG Base Directory Specification Compliant:** All Zsh-related configurations are now located in `xdg/.config/zsh`, adhering to the XDG standard for a cleaner home directory.
- **Streamlined Zsh Configuration:** The main `.zshrc` is minimal, focusing on sourcing essential files, with detailed configurations moved to XDG-compliant directories.
- **Powerlevel10k and Oh My Zsh:** The dotfiles include a pre-configured Powerlevel10k theme and Oh My Zsh for a powerful and visually appealing shell experience.
- **Global .gitignore:** A global `.gitignore` file (`git/.gitignore`) is included to prevent common unnecessary files from being committed to any repository.
- **Active Secret Scanner:** A pre-commit/pre-push Git hook (`git/hook-reminder.sh`) actively scans staged changes for API keys, tokens, passwords, and private keys — blocking the commit if secrets are detected.
- **Gemini CLI Aliases:** A suite of aliases and functions for the Gemini CLI (`xdg/.config/zsh/aliases/gemini/`), including clipboard, save-to-file, and logging helpers.
- **macOS Defaults:** The installation script includes a number of macOS-specific configurations to improve the user experience.
- **Custom Scripts:** Easily add and manage your own shell scripts.
- **Secrets Management:** Securely handle sensitive information using 1Password CLI.
- **Automated Testing:** Ensure your configurations work as expected with Bats-Core.
- **CI Pipeline:** GitHub Actions workflow runs ShellCheck linting and Bats tests on every push and PR.
- **Makefile:** Convenient `make install`, `make test`, `make lint`, `make backup`, `make uninstall` targets.
- **dotpi in Codespaces:** In [GitHub Codespaces](https://github.com/features/codespaces) by default, `install.sh` clones [AlainS7/dotpi-remote](https://github.com/AlainS7/dotpi-remote) into `~/.pi`. Env checks are not spoof-proof; see [docs: dotpi](./docs/README.md#dotpi-companion-repository-codespaces).
- **Pi CLI in Codespaces:** Same path installs [`pi`](https://pi.dev), optional `pi/codespaces-packages.txt` lines, then `pi install` on each package-looking folder under `~/.pi/extensions` after dotpi submodules sync. Not per-repo; see [docs: pi](./docs/README.md#pi-cli-on-every-codespace).

## Documentation

For detailed information on how to use, customize, and extend these dotfiles, please refer to the [full documentation](./docs/README.md).

## Installation

To install the dotfiles, simply clone this repository and run the `install.sh` script:

```sh
git clone https://github.com/AlainS7/dotfiles.git
cd dotfiles
./install.sh
```

The script will back up any existing dotfiles to a `~/.dotfiles-backup` directory before creating symlinks.

### Additional Install Options

```sh
./install.sh --dry-run          # Preview changes without making them
./install.sh --restore-backup   # Restore the most recent backup
./install.sh --generate-readme  # Regenerate README.md
```

### Using Make

```sh
make install    # Run full installation
make test       # Run all Bats tests
make lint       # Run ShellCheck on all scripts
make backup     # Backup dotfiles to remote repo
make uninstall  # Remove symlinks (with optional backup restore)
make help       # Show all available targets
```

## Customization

- **Main Zsh Configuration:** The primary Zsh configuration is now in `xdg/.config/zsh/.zshrc`.
- **Environment Variables:** Essential environment variables are set in `zsh/.zshenv`.
- **Aliases:** To add or modify aliases, edit the files in the `xdg/.config/zsh/aliases` directory.
- **Functions:** To add or modify functions, edit the files in the `xdg/.config/zsh/functions` directory.

## Usage Examples for Custom Functions

### mkcd

Create a directory and change into it:

```sh
mkcd my_new_folder
```

### explain

Explain a command output or text using Gemini:

```sh
ls -l | explain
explain "What does this error mean?"
```

### extract

Extract any supported archive:

```sh
extract archive.tar.gz
extract file.zip
```

- **Homebrew Packages:** To add or remove Homebrew packages, edit the `install.sh` script.
