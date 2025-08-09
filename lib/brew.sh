#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]:-${(%):-%x}}")/utils.sh"

install_homebrew() {
    if ! command -v brew &>/dev/null; then
        print_status "Installing Homebrew..."
        NONINTERACTIVE=true /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Attempt to add Homebrew to the current session's PATH
        local brew_path=""
        if [ -f "/opt/homebrew/bin/brew" ]; then # Apple Silicon
            brew_path="/opt/homebrew/bin/brew"
        elif [ -f "/usr/local/bin/brew" ]; then # Intel Macs
            brew_path="/usr/local/bin/brew"
        elif [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then # Linux
            brew_path="/home/linuxbrew/.linuxbrew/bin/brew"
        fi

        if [ -n "$brew_path" ]; then
            eval "$("$brew_path" shellenv)"
            # Add to .zprofile for future login shells
            echo "eval \"\$(\"$brew_path\" shellenv)\"" >>~/.zprofile
            print_success "Homebrew installed and configured for current and future sessions."
        else
            print_error "Homebrew installed, but 'brew' command not found in expected paths."
            print_error "Please add Homebrew to your PATH manually."
            return 1
        fi
    else
        print_success "Homebrew is already installed."
    fi
}

install_packages_from_brewfile() {
    print_status "Installing packages from Brewfile..."
    if ! command -v brew &>/dev/null; then
        print_error "Homebrew is not installed. Cannot proceed with package installation."
        return 1
    fi

    local brewfile_path="$DOTFILES_DIR/lib/Brewfile"
    if [ ! -f "$brewfile_path" ]; then
        print_error "Brewfile not found at $brewfile_path"
        return 1
    fi

    if brew bundle --file="$brewfile_path"; then
        print_success "All packages from Brewfile are installed."
    else
        print_error "Failed to install packages from Brewfile."
        return 1
    fi

    # Special post-install for fzf
    if [ -f "$(brew --prefix)/opt/fzf/install" ]; then
        print_status "Running fzf post-installation script..."
        yes | "$(brew --prefix)/opt/fzf/install" --all
        print_success "fzf keybindings and completion installed."
    fi
}