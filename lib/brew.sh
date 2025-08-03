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

install_useful_tools() {
    print_status "Installing command-line tools via Homebrew..."
    local tools=("fzf" "bat" "eza" "tree" "git" "curl" "wget" "jq")
    # "1password-cli" "bats-core"  not installed
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &>/dev/null; then
            print_status "Installing $tool..."
            brew install "$tool"

            # Special post-install for fzf
            if [ "$tool" == "fzf" ]; then
                print_status "Running fzf post-installation script..."
                # Use `yes` to auto-confirm prompts from the fzf install script
                if [ -f "$(brew --prefix)/opt/fzf/install" ]; then
                    yes | "$(brew --prefix)/opt/fzf/install" --all
                    print_success "fzf keybindings and completion installed."
                else
                    print_warning "fzf post-install script not found. You may need to run it manually."
                fi
            fi
        else
            print_success "$tool is already installed."
        fi
    done
}