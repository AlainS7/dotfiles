# My Dotfiles

This repository contains my personal dotfiles for macOS and Linux. The setup is automated via an installation script that handles everything from package installation to configuration symlinking.

## Features

* **Automated Installation:** The `install.sh` script automates the entire setup process.
* **Cross-Platform Compatibility:** The dotfiles are designed to work on both macOS and Linux.
* **Homebrew-based:** Homebrew is used to manage packages, ensuring consistency across platforms.
* **XDG Base Directory Specification Compliant:** All Zsh-related configurations are now located in `xdg/.config/zsh`, adhering to the XDG standard for a cleaner home directory.
* **Streamlined Zsh Configuration:** The main `.zshrc` is minimal, focusing on sourcing essential files, with detailed configurations moved to XDG-compliant directories.
* **Powerlevel10k and Oh My Zsh:** The dotfiles include a pre-configured Powerlevel10k theme and Oh My Zsh for a powerful and visually appealing shell experience.
* **Global .gitignore:** A global `.gitignore` file is included to prevent common unnecessary files from being committed to any repository.
* **macOS Defaults:** The installation script includes a number of macOS-specific configurations to improve the user experience.
* **Custom Scripts:** Easily add and manage your own shell scripts.
* **Secrets Management:** Securely handle sensitive information using 1Password CLI.
* **Automated Testing:** Ensure your configurations work as expected with Bats-Core.

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

## Customization

* **Main Zsh Configuration:** The primary Zsh configuration is now in `xdg/.config/zsh/.zshrc`.
* **Environment Variables:** Essential environment variables are set in `zsh/.zshenv`.
* **Aliases:** To add or modify aliases, edit the files in the `xdg/.config/zsh/aliases` directory.
* **Functions:** To add or modify functions, edit the files in the `xdg/.config/zsh/functions` directory.
* **Homebrew Packages:** To add or remove Homebrew packages, edit the `install.sh` script.
