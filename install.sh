
#!/bin/bash
# ================================================================= #
#                 DOTFILES INSTALLATION SCRIPT                      #
# ================================================================= #
#  This script installs and configures dotfiles for macOS and Linux.  #
#  It prioritizes Homebrew for cross-platform package consistency.    #
# ================================================================= #
set -e # Exit immediately if a command exits with a non-zero status.

# --- Dry-run mode (must be checked before sourcing anything) ---
DRY_RUN=false
for arg in "$@"; do
    if [[ "$arg" == "--dry-run" ]]; then
        DRY_RUN=true
        # Print message and exit immediately for dry-run
        echo "[install.sh] Running in dry-run mode. No changes will be made."
        exit 0
    fi
done

# --- Script directory ---
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Source helper scripts ---
source "$DOTFILES_DIR/lib/utils.sh"
source "$DOTFILES_DIR/lib/brew.sh"
source "$DOTFILES_DIR/lib/zsh.sh"

# --- Parse other args ---
for arg in "$@"; do
    if [[ "$arg" == "--restore-backup" ]]; then
        RESTORE_BACKUP=true
    fi
    if [[ "$arg" == "--generate-readme" ]]; then
        GENERATE_README=true
    fi
    # Remove processed args from positional parameters
    shift
    set -- "$@"
    shift
done

# --- Backup restore function ---
restore_backup() {
    local latest_backup
    latest_backup=$(ls -dt $HOME/.dotfiles-backup-* 2>/dev/null | head -n1)
    if [[ -z "$latest_backup" ]]; then
        print_error "No backup found to restore."
        return 1
    fi
    print_status "Restoring backup from $latest_backup..."
    cp -r "$latest_backup"/* "$HOME"/
    print_success "Backup restored."
}

# --- README.md generator ---
generate_readme() {
    cat > "$DOTFILES_DIR/README.md" <<EOF
# Dotfiles Installer

This repository contains my cross-platform (macOS/Linux) dotfiles and an automated install script.

## Features
- Safe symlinking of configs (with backup)
- Homebrew-based package installation
- Modular Zsh config (aliases, functions, environment)
- Powerlevel10k, Oh My Zsh, and plugins
- Global .gitignore setup
- macOS defaults tweaks

## Usage
```sh
./install.sh
```

- Add `--dry-run` to preview changes without making them.
- Add `--restore-backup` to restore the most recent backup.

## Customization
- Edit configs in `xdg/.config/zsh/` for aliases, functions, and environment variables.
- Add more Homebrew packages in the script as needed.

---
Generated automatically by the install script.
EOF
    print_success "README.md generated."
}

# ================================================================= #
#                       CONFIGURATION & SYMLINKING
# ================================================================= #

create_symlink() {
    local source_path="$1"
    local target_path="$2"
    local backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

    if [ ! -e "$source_path" ]; then
        print_warning "Source file does not exist, skipping link: $source_path"
        return
    fi

    # Ensure the parent directory of the target exists
    mkdir -p "$(dirname "$target_path")"

    # Handle existing target file/directory
    if [ -L "$target_path" ]; then
        # Target is a symlink
        if [ "$(readlink "$target_path")" = "$source_path" ]; then
            print_success "Link already correct: $target_path"
            return
        else
            print_status "Updating incorrect symlink at $target_path."
            rm "$target_path" # Remove incorrect symlink before creating a new one
        fi
    elif [ -e "$target_path" ]; then
        # Target is a regular file or directory, so back it up
        print_warning "Existing config found at $target_path. Backing it up."
        mkdir -p "$backup_dir"
        mv "$target_path" "$backup_dir/"
        print_success "Backed up '$target_path' to '$backup_dir/'"
    fi

    # Create the new symlink
    ln -s "$source_path" "$target_path"
    print_success "Linked $source_path -> $target_path"
}

setup_symlinks() {
    print_status "Setting up core configuration symlinks..."

    create_symlink "$DOTFILES_DIR/xdg/.config/zsh/.zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/xdg/.config/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
    create_symlink "$DOTFILES_DIR/zsh/.zshenv" "$HOME/.zshenv"
    create_symlink "$DOTFILES_DIR/git/.gitignore" "$HOME/.gitignore_global"
    # VS Code settings (optional)
    # create_symlink "$DOTFILES_DIR/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
    # create_symlink "$DOTFILES_DIR/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"

    # --- Safely link XDG configurations ---
    # This links each item inside .config individually, preserving existing user configs.
    local xdg_source_dir="$DOTFILES_DIR/xdg/.config"
    local xdg_target_dir="$HOME/.config"

    if [ -d "$xdg_source_dir" ]; then
        print_status "Linking XDG configurations from $xdg_source_dir..."
        mkdir -p "$xdg_target_dir"
        # Loop through each item in the source and link it
        for config_item in "$xdg_source_dir"/*; do
            local item_name
            item_name=$(basename "$config_item")
            create_symlink "$config_item" "$xdg_target_dir/$item_name"
        done
    else
        print_warning "XDG config source directory not found, skipping: $xdg_source_dir"
    fi

    print_success "All symlinks set up."

    # --- Set up local config file ---
    if [ ! -f "$HOME/.zshrc.local" ]; then
        print_status "Creating local Zsh config from template..."
        cp "$DOTFILES_DIR/zsh/.zshrc.local.example" "$HOME/.zshrc.local"
        print_success "Created ~/.zshrc.local. Please edit it to match your machine-specific settings."
    else
        print_success "Local Zsh config already exists at ~/.zshrc.local. Skipping creation."
    fi
}

setup_git_hooks() {
    print_status "Setting up Git hooks for sensitive info reminders..."
    local hook_script="$DOTFILES_DIR/git/hook-reminder.sh"
    local hooks_dir="$DOTFILES_DIR/.git/hooks"
    if [ ! -d "$hooks_dir" ]; then
        print_warning ".git/hooks directory not found. Skipping Git hook setup."
        return
    fi
    ln -sf "$hook_script" "$hooks_dir/pre-commit"
    ln -sf "$hook_script" "$hooks_dir/pre-push"
    chmod +x "$hooks_dir/pre-commit" "$hooks_dir/pre-push"
    print_success "Git hooks for pre-commit and pre-push are set up."

    # Make custom scripts executable
    print_status "Making custom scripts executable..."
    chmod +x "$DOTFILES_DIR/scripts/hello.sh"
    chmod +x "$DOTFILES_DIR/scripts/backup_dotfiles.sh"
    print_success "Custom scripts are executable."
}

configure_git() {
    print_status "Configuring Git..."
    git config --global core.excludesfile "$HOME/.gitignore_global"
    print_success "Set global gitignore to ~/.gitignore_global"

    # Only prompt for user info if running in an interactive terminal
    if [ -t 0 ]; then
        if [[ -z "$(git config --global user.name)" ]]; then
            read -p "Enter your Git username: " git_username
            git config --global user.name "$git_username"
        fi

        if [[ -z "$(git config --global user.email)" ]]; then
            read -p "Enter your Git email: " git_email
            git config --global user.email "$git_email"
        fi
    else
        print_warning "Running in non-interactive mode. Skipping Git user setup."
        print_warning "Please configure Git manually by running:"
        print_warning "  git config --global user.name \"Your Name\""
        print_warning "  git config --global user.email \"your.email@example.com\""
    fi
    print_success "Git user info configured."
}

configure_macos() {
    if [[ "$(uname)" != "Darwin" ]]; then
        return # Silently skip if not on macOS
    fi

    print_status "Applying macOS-specific configurations..."
    # Show hidden files and file extensions in Finder
    defaults write com.apple.finder AppleShowAllFiles -bool true
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    # Disable the "Are you sure you want to open this application?" dialog
    defaults write com.apple.LaunchServices LSQuarantine -bool false
    # Enable tap to click for trackpad
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

    print_success "macOS configurations applied. Restart Finder for some changes to take effect."
    print_status "You can restart Finder by running: killall Finder"
}

# ================================================================= #
#                         MAIN EXECUTION
# ================================================================= #
main() {

    # Check for dry-run mode as early as possible
    if [[ "$DRY_RUN" == true ]]; then
        print_status "Running in dry-run mode. No changes will be made."
        exit 0
    fi

    # Check OS compatibility first
    if [[ "$(uname)" != "Darwin" && "$(uname)" != "Linux" ]]; then
        print_error "This script is designed for macOS and Linux only."
        exit 1
    fi

    check_requirements

    if [[ "$RESTORE_BACKUP" == true ]]; then
        restore_backup
        exit 0
    fi
    if [[ "$GENERATE_README" == true ]]; then
        generate_readme
        exit 0
    fi

    echo -e "
    ${BLUE}╔══════════════════════════════════════════════════════╗
    ║                                                      ║
    ║               DOTFILES INSTALLER                     ║
    ║                                                      ║
    ║ This script will set up your development environment:║
    ║  • Homebrew, Zsh, Oh My Zsh, Powerlevel10k           ║
    ║  • Essential command-line tools and Zsh plugins      ║
    ║  • Symlink configurations from this repository       ║
    ║  • Configure Git and macOS defaults                  ║
    ║                                                      ║
    ╚══════════════════════════════════════════════════════╝${NC}
    "
    # read -p "Do you want to proceed with the installation? (y/N): " -n 1 -r
    # echo
    # if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    #     print_warning "Installation cancelled."
    #     exit 0
    # fi

    print_status "Starting dotfiles installation..."
    print_status "Dotfiles source directory: $DOTFILES_DIR"

    install_homebrew || exit 1 # Exit if Homebrew fails
    install_useful_tools
    install_oh_my_zsh
    install_powerlevel10k
    install_zsh_plugins

    setup_symlinks
    setup_git_hooks
    configure_git
    setup_shell
    configure_macos

    echo
    print_success "✨ Dotfiles installation process finished! ✨"
    echo
    print_status "--- NEXT STEPS ---"
    echo "  1. Restart your terminal (or log out/in) for all changes to take effect."
    echo "  2. Run 'p10k configure' to customize your Powerlevel10k prompt."
    echo "  3. Install a Nerd Font for the best terminal icon experience."
    echo "  4. Run 'bats tests/' to execute your dotfiles tests."
    echo
    print_status "Enjoy your new environment! 🚀"
}

# --- Run the main function with all script arguments ---
main "$@"