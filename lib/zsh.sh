#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        print_status "Installing Oh My Zsh..."
        # The `"" --unattended` arguments run the installer non-interactively
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh My Zsh installed."
    else
        print_success "Oh My Zsh is already installed."
    fi
}

install_powerlevel10k() {
    local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    if [[ ! -d "$p10k_dir" ]]; then
        print_status "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
        print_success "Powerlevel10k installed."
    else
        print_success "Powerlevel10k is already installed."
    fi
}

install_zsh_plugins() {
    local custom_plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    # zsh-autosuggestions
    if [[ ! -d "$custom_plugins_dir/zsh-autosuggestions" ]]; then
        print_status "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$custom_plugins_dir/zsh-autosuggestions"
        print_success "zsh-autosuggestions installed."
    else
        print_success "zsh-autosuggestions is already installed."
    fi

    # zsh-syntax-highlighting
    if [[ ! -d "$custom_plugins_dir/zsh-syntax-highlighting" ]]; then
        print_status "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$custom_plugins_dir/zsh-syntax-highlighting"
        print_success "zsh-syntax-highlighting installed."
    else
        print_success "zsh-syntax-highlighting is already installed."
    fi
}

setup_shell() {
    local zsh_path
    if ! zsh_path=$(which zsh); then
        print_error "Zsh not found. Cannot set it as the default shell."
        return 1
    fi

    # Change default shell to zsh if it's not already
    if [[ "$SHELL" != "$zsh_path" ]]; then
        print_status "Attempting to set Zsh as the default shell..."

        # 'chsh' requires the new shell to be listed in /etc/shells
        if ! grep -qF "$zsh_path" /etc/shells; then
            print_warning "Zsh path '$zsh_path' not found in /etc/shells."
            print_status "Adding it to /etc/shells (requires sudo)..."
            if echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null; then
                print_success "Successfully added Zsh to /etc/shells."
            else
                print_error "Failed to add Zsh to /etc/shells. Cannot set as default."
                return 1
            fi
        fi

        # Attempt to change shell. `chsh` often needs an interactive password prompt.
        # It's safer to advise the user to run the command themselves.
        print_warning "Changing the default shell requires administrator privileges."
        print_warning "Please run the following command manually to complete the process:"
        echo -e "\n    ${YELLOW}chsh -s \"$zsh_path\"${NC}\n"
        print_warning "You will need to log out and log back in for the change to take effect."
    else
        print_success "Zsh is already the default shell."
    fi
}