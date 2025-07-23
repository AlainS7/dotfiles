# My Dotfiles

This repository contains my personal dotfiles for macOS and Linux. The setup is automated via an installation script that handles everything from package installation to configuration symlinking.

## Features

* **Automated Installation:** The `install.sh` script automates the entire setup process.
* **Cross-Platform Compatibility:** The dotfiles are designed to work on both macOS and Linux.
* **Homebrew-based:** Homebrew is used to manage packages, ensuring consistency across platforms.
* **Modular Zsh Configuration:** The Zsh configuration is broken down into smaller, more manageable files for aliases, functions, and environment variables.
* **Powerlevel10k and Oh My Zsh:** The dotfiles include a pre-configured Powerlevel10k theme and Oh My Zsh for a powerful and visually appealing shell experience.
* **Global .gitignore:** A global `.gitignore` file is included to prevent common unnecessary files from being committed to any repository.
* **macOS Defaults:** The installation script includes a number of macOS-specific configurations to improve the user experience.

## Installation

To install the dotfiles, simply clone this repository and run the `install.sh` script:

```sh
git clone https://github.com/AlainS7/dotfiles.git
cd dotfiles
./install.sh
```

The script will back up any existing dotfiles to a `~/.dotfiles-backup` directory before creating symlinks.

## Customization

* **Aliases:** To add or modify aliases, edit the files in the `xdg/.config/zsh/aliases` directory.
* **Functions:** To add or modify functions, edit the files in the `xdg/.config/zsh/functions` directory.
* **Environment Variables:** To add or modify environment variables, edit the files in the `xdg/.config/zsh/environment` directory.
* **Homebrew Packages:** To add or remove Homebrew packages, edit the `install.sh` script.
