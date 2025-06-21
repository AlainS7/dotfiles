#!/bin/bash
# ================================================================= #
#                 DOTFILES INSTALLATION SCRIPT                      #
# ================================================================= #
#  This script installs and configures dotfiles for macOS and Linux.  #
#  It prioritizes Homebrew for cross-platform package consistency.    #
# ================================================================= #
set -e # Exit immediately if a command exits with a non-zero status.

# Pre-emptively create a blank .zshrc in the home directory to prevent
# Zsh's first-time setup wizard from asking to create one.
touch ~/.zshrc

# --- Colors for formatted output ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Helper functions for logging ---
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}
print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}
print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}
print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# --- Pre-flight checks for required commands ---
check_requirements() {
    local missing=()
    for cmd in git curl; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done
    if (( ${#missing[@]} > 0 )); then
        print_error "Missing required commands: ${missing[*]}"
        print_error "Please install them and re-run this script."
        exit 1
    fi
}

# --- Script directory ---
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Dry-run mode ---
DRY_RUN=false
for arg in "$@"; do
    if [[ "$arg" == "--dry-run" ]]; then
        DRY_RUN=true
        print_status "Running in dry-run mode. No changes will be made."
    fi
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
#                      DEPENDENCY INSTALLATION
# ================================================================= #

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
            echo "eval \"\$($brew_path shellenv)\"" >>~/.zprofile
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

install_useful_tools() {
    print_status "Installing command-line tools via Homebrew..."
    local tools=("fzf" "bat" "eza" "tree" "git" "curl" "wget" "jq")

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

    create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
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

    if [[ "$DRY_RUN" == true ]]; then
        print_status "Dry-run: install_homebrew, install_useful_tools, install_oh_my_zsh, install_powerlevel10k, install_zsh_plugins, setup_symlinks, configure_git, setup_shell, configure_macos would be run."
        exit 0
    fi

    install_homebrew || exit 1 # Exit if Homebrew fails
    install_useful_tools
    install_oh_my_zsh
    install_powerlevel10k
    install_zsh_plugins

    setup_symlinks
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
    echo
    print_status "Enjoy your new environment! 🚀"
}

# --- Run the main function with all script arguments ---
main "$@"