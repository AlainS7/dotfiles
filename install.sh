#!/bin/bash

# =================================================================
# DOTFILES INSTALLATION SCRIPT
# =================================================================
# This script installs and configures dotfiles for macOS
# Date: $(date +%Y-%m-%d)
# =================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
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

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_status "Starting dotfiles installation..."
print_status "Dotfiles directory: $DOTFILES_DIR"

# =================================================================
# BACKUP EXISTING CONFIGURATIONS
# =================================================================

backup_existing_config() {
    local file="$1"
    local backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
    
    if [[ -e "$file" && ! -L "$file" ]]; then
        print_warning "Backing up existing $file"
        mkdir -p "$backup_dir"
        mv "$file" "$backup_dir/"
        print_success "Backed up to $backup_dir"
    fi
}

# =================================================================
# INSTALL DEPENDENCIES
# =================================================================

# install_homebrew() {
#     if ! command -v brew &> /dev/null; then
#         print_status "Installing Homebrew..."
#         /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
#         # Add Homebrew to PATH for Apple Silicon Macs
#         if [[ $(uname -m) == "arm64" ]]; then
#             echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
#             eval "$(/opt/homebrew/bin/brew shellenv)"
#         fi
        
#         print_success "Homebrew installed successfully"
#     else
#         print_success "Homebrew already installed"
#     fi
# }

install_homebrew() {
    if ! command -v brew &> /dev/null; then
        print_status "Installing Homebrew..."
        # Execute the Homebrew installation script
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # --- IMPORTANT: Source Homebrew's environment variables immediately after installation ---
        # This ensures 'brew' command is found by subsequent commands in the script.
        
        LOCAL_BREW_PATH=""

        # Check common Homebrew installation paths for the executable
        if [ -f "/opt/homebrew/bin/brew" ]; then
            LOCAL_BREW_PATH="/opt/homebrew/bin/brew"
        elif [ -f "/usr/local/bin/brew" ]; then
            LOCAL_BREW_PATH="/usr/local/bin/brew"
        elif [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then # <-- This is the path we just found!
            LOCAL_BREW_PATH="/home/linuxbrew/.linuxbrew/bin/brew"
        fi

        if [ -n "$LOCAL_BREW_PATH" ]; then # If a path was found
            eval "$($LOCAL_BREW_PATH shellenv)"
            # Add to .zprofile for future sessions (adjust if user uses bash and needs .bashrc/.bash_profile)
            echo "eval \"\$($LOCAL_BREW_PATH shellenv)\"" >> ~/.zprofile
            print_success "Homebrew installed successfully and PATH updated for current and future sessions."
        else
            print_error "Homebrew was installed, but 'brew' command not found in expected paths after installation."
            print_error "Checked: /opt/homebrew/bin/brew, /usr/local/bin/brew, /home/linuxbrew/.linuxbrew/bin/brew"
            print_error "Please manually run 'find / -name brew 2>/dev/null' to locate brew and set up your environment."
            return 1 # Indicate an error from the function
        fi
        
    else
        print_success "Homebrew already installed"
    fi
}

install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        print_status "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh My Zsh installed successfully"
    else
        print_success "Oh My Zsh already installed"
    fi
}

install_powerlevel10k() {
    local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    
    if [[ ! -d "$p10k_dir" ]]; then
        print_status "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
        print_success "Powerlevel10k installed successfully"
    else
        print_success "Powerlevel10k already installed"
    fi
}

install_zsh_plugins() {
    local custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    # zsh-autosuggestions
    if [[ ! -d "$custom_dir/plugins/zsh-autosuggestions" ]]; then
        print_status "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$custom_dir/plugins/zsh-autosuggestions"
        print_success "zsh-autosuggestions installed"
    else
        print_success "zsh-autosuggestions already installed"
    fi
    
    # zsh-syntax-highlighting
    if [[ ! -d "$custom_dir/plugins/zsh-syntax-highlighting" ]]; then
        print_status "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$custom_dir/plugins/zsh-syntax-highlighting"
        print_success "zsh-syntax-highlighting installed"
    else
        print_success "zsh-syntax-highlighting already installed"
    fi
}

install_useful_tools() {
    print_status "Installing useful command-line tools..."
    
    # List of tools to install
    local tools=(
        "fzf"       # Fuzzy finder
        "bat"       # Better cat with syntax highlighting
        "exa"       # Better ls
        "tree"      # Directory tree viewer
        "git"       # Git (ensure latest version)
        "curl"      # HTTP client
        "wget"      # File downloader
        "jq"        # JSON processor
    )
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            print_status "Installing $tool..."
            brew install "$tool"
        else
            print_success "$tool already installed"
        fi
    done
}

# =================================================================
# SYMLINK CONFIGURATIONS
# =================================================================

create_symlink() {
    local source="$1"
    local target="$2"
    
    # Create target directory if it doesn't exist
    local target_dir="$(dirname "$target")"
    mkdir -p "$target_dir"
    
    # Backup existing file/directory if it exists and is not a symlink
    backup_existing_config "$target"
    
    # Create symlink
    ln -sf "$source" "$target"
    print_success "Linked $source -> $target"
}

setup_symlinks() {
    print_status "Setting up configuration symlinks..."
    
    # ZSH configurations
    create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
    
    # XDG config directory (primary config location)
    create_symlink "$DOTFILES_DIR/xdg/.config" "$HOME/.config"
    
    # Git configuration
    create_symlink "$DOTFILES_DIR/git/.gitignore" "$HOME/.gitignore_global"
    
    print_success "All symlinks created successfully"
}

# =================================================================
# GIT CONFIGURATION
# =================================================================

configure_git() {
    print_status "Configuring Git..."
    
    # Set global gitignore
    git config --global core.excludesfile "$HOME/.gitignore_global"
    print_success "Global gitignore configured"
    
    # Check if user name and email are set
    if [[ -z "$(git config --global user.name)" ]]; then
        read -p "Enter your Git username: " git_username
        git config --global user.name "$git_username"
    fi
    
    if [[ -z "$(git config --global user.email)" ]]; then
        read -p "Enter your Git email: " git_email
        git config --global user.email "$git_email"
    fi
    
    print_success "Git configuration completed"
}

# =================================================================
# SHELL CONFIGURATION
# =================================================================

setup_shell() {
    # Change default shell to zsh if not already
    if [[ "$SHELL" != */zsh ]]; then
        print_status "Changing default shell to zsh..."
        chsh -s "$(which zsh)"
        print_success "Default shell changed to zsh"
        print_warning "Please restart your terminal or log out and back in for the shell change to take effect"
    else
        print_success "Zsh is already the default shell"
    fi
}

# =================================================================
# MACOS SPECIFIC CONFIGURATIONS
# =================================================================

configure_macos() {
    if [[ "$(uname)" != "Darwin" ]]; then
        print_warning "Skipping macOS configurations (not running on macOS)"
        return
    fi
    
    print_status "Applying macOS-specific configurations..."
    
    # Show hidden files in Finder
    defaults write com.apple.finder AppleShowAllFiles -bool true
    
    # Show file extensions in Finder
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    
    # Disable the "Are you sure you want to open this application?" dialog
    defaults write com.apple.LaunchServices LSQuarantine -bool false
    
    # Enable tap to click for trackpad
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    
    print_success "macOS configurations applied"
    print_warning "Some changes may require a restart to take effect"
}

# =================================================================
# MAIN INSTALLATION PROCESS
# =================================================================

main() {
    echo "
    ╔══════════════════════════════════════════════════════╗
    ║                                                      ║
    ║               DOTFILES INSTALLER                     ║
    ║                                                      ║
    ║  This script will install and configure:            ║
    ║  • Oh My Zsh with Powerlevel10k theme              ║
    ║  • ZSH plugins (autosuggestions, syntax highlight)  ║
    ║  • Useful command-line tools via Homebrew          ║
    ║  • Git configuration                                ║
    ║  • Custom aliases, functions, and environment       ║
    ║  • macOS-specific optimizations                     ║
    ║                                                      ║
    ╚══════════════════════════════════════════════════════╝
    "
    
    read -p "Do you want to proceed with the installation? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Installation cancelled"
        exit 0
    fi
    
    print_status "Starting installation process..."
    
    # Install dependencies
    install_homebrew
    install_useful_tools
    install_oh_my_zsh
    install_powerlevel10k
    install_zsh_plugins
    
    # Setup configurations
    setup_symlinks
    configure_git
    configure_macos
    setup_shell
    
    print_success "✨ Dotfiles installation completed successfully!"
    echo
    print_status "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Configure Powerlevel10k by running: p10k configure"
    echo "  3. Install a Nerd Font for better terminal icons"
    echo "  4. Customize your configurations in ~/.config/zsh/"
    echo
    print_status "Enjoy your new development environment! 🚀"
}

# =================================================================
# SCRIPT EXECUTION
# =================================================================

# Check if running on macOS or Linux
if [[ "$(uname)" != "Darwin" && "$(uname)" != "Linux" ]]; then
    print_error "This script is designed for macOS and Linux only"
    exit 1
fi

# Run main installation
main "$@"
