#!/usr/bin/env bash

# Common setup for all bats tests

setup_symlinks_for_tests() {
    # Create the symlinks required for the tests to run
    # This is a simplified version of the setup_symlinks function in install.sh

    # Symlink .zshenv
    if [ ! -L "$HOME/.zshenv" ]; then
        ln -s "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"
    fi

    # Symlink .p10k.zsh
    if [ ! -L "$HOME/.p10k.zsh" ]; then
        ln -s "$DOTFILES_DIR/xdg/.config/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
    fi
}

install_oh_my_zsh_for_tests() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
    fi

    local custom_plugins_dir="$HOME/.oh-my-zsh/custom/plugins"
    mkdir -p "$custom_plugins_dir"

    if [ ! -d "$custom_plugins_dir/zsh-autosuggestions" ]; then
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$custom_plugins_dir/zsh-autosuggestions"
    fi

    if [ ! -d "$custom_plugins_dir/zsh-syntax-highlighting" ]; then
        git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$custom_plugins_dir/zsh-syntax-highlighting"
    fi

    local custom_themes_dir="$HOME/.oh-my-zsh/custom/themes"
    mkdir -p "$custom_themes_dir"

    if [ ! -d "$custom_themes_dir/powerlevel10k" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$custom_themes_dir/powerlevel10k"
    fi
}
