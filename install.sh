#!/usr/bin/env zsh
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
    fi
done

# --- Script directory ---
# Compatible with both Bash and Zsh
if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
fi

# --- Source helper scripts ---
source "$DOTFILES_DIR/lib/utils.sh"
source "$DOTFILES_DIR/lib/brew.sh"
source "$DOTFILES_DIR/lib/zsh.sh"

# lib/utils.sh uses set -u; these flags must exist before main() reads them.
RESTORE_BACKUP=false
GENERATE_README=false

# --- Parse other args ---

# --- Robust argument parsing ---
while (( $# > 0 )); do
    case "$1" in
        --restore-backup)
            RESTORE_BACKUP=true
            ;;
        --generate-readme)
            GENERATE_README=true
            ;;
    esac
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
    if cp -r "$latest_backup"/* "$HOME"/; then
        print_success "Backup restored."
    else
        print_error "Failed to restore backup from $latest_backup."
        return 1
    fi
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
        if mv "$target_path" "$backup_dir/"; then
            print_success "Backed up '$target_path' to '$backup_dir/'"
        else
            print_error "Failed to back up '$target_path' to '$backup_dir/'"
            return 1
        fi
    fi

    # Create the new symlink
    if ln -s "$source_path" "$target_path"; then
        print_success "Linked $source_path -> $target_path"
    else
        print_error "Failed to create symlink: $source_path -> $target_path"
        return 1
    fi
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
        if cp "$DOTFILES_DIR/zsh/.zshrc.local.example" "$HOME/.zshrc.local"; then
            print_success "Created ~/.zshrc.local. Please edit it to match your machine-specific settings."
        else
            print_error "Failed to create ~/.zshrc.local from template."
        fi
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
    chmod +x "$DOTFILES_DIR/scripts/backup-dotfiles.sh"
    chmod +x "$DOTFILES_DIR/scripts/uninstall.sh"
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

# True when running in a real GitHub Codespace (Linux + GH env). Not cryptographic attestation.
is_github_codespaces() {
    [[ "$(uname)" != "Darwin" ]] && [[ "${CODESPACES:-}" == "true" ]] && [[ -n "${CODESPACE_NAME:-}" ]]
}

# Init/update git submodules under dotpi (extension repos checked in as submodules).
dotpi_sync_submodules() {
    local dotpi_dir="$1"
    [[ -d "$dotpi_dir/.git" ]] || return 0
    [[ -f "$dotpi_dir/.gitmodules" ]] || return 0
    print_status "Codespaces: git submodule update --init --recursive in $dotpi_dir..."
    if git -C "$dotpi_dir" submodule update --init --recursive; then
        print_success "dotpi submodules ready."
    else
        print_warning "dotpi submodule update failed. For submodules use a full clone (omit DOTPI_SHALLOW_CLONE)."
    fi
}

# Clone dotpi into ~/.pi only in GitHub Codespaces: CODESPACES=true and CODESPACE_NAME set (per GH docs), never on macOS.
# Default clone uses --recurse-submodules (no shallow) so submodule extension repos populate. Set DOTPI_SHALLOW_CLONE=1 for
# fast shallow clone without submodule recursion (submodules may be empty). Override: DOTPI_DIR, DOTPI_REPO_URL. DOTPI_SKIP=1 disables.
setup_dotpi_for_codespaces() {
    if [[ -n "${DOTPI_SKIP:-}" ]]; then
        return
    fi
    if ! is_github_codespaces; then
        return
    fi

    local dotpi_dir="${DOTPI_DIR:-$HOME/.pi}"
    local dotpi_url="${DOTPI_REPO_URL:-https://github.com/AlainS7/dotpi-remote.git}"

    if [[ -d "$dotpi_dir/.git" ]]; then
        print_success ".pi repo already present at $dotpi_dir"
        dotpi_sync_submodules "$dotpi_dir"
        return
    fi

    print_status "Codespaces: cloning dotpi to $dotpi_dir..."
    if [[ "${DOTPI_SHALLOW_CLONE:-}" == "1" ]]; then
        if git clone --depth 1 "$dotpi_url" "$dotpi_dir"; then
            print_success ".pi cloned (shallow; submodules may be incomplete)."
        else
            print_warning ".pi clone failed. If the repo is private, ensure Git credential helper is configured in this codespace (e.g. gh auth setup-git)."
            return
        fi
    else
        if git clone --recurse-submodules "$dotpi_url" "$dotpi_dir"; then
            print_success ".pi cloned to $dotpi_dir (with submodules)."
        else
            print_warning ".pi clone failed. If the repo is private, ensure Git credential helper is configured in this codespace (e.g. gh auth setup-git)."
            return
        fi
    fi
    dotpi_sync_submodules "$dotpi_dir"
}

# Append npm global bin to PATH in ~/.zprofile once (pi lives there after npm install -g).
ensure_npm_global_on_path() {
    command -v npm &>/dev/null || return 0
    local ng
    ng="$(npm prefix -g 2>/dev/null)/bin"
    [[ -d "$ng" ]] || return 0
    [[ ":$PATH:" == *":$ng:"* ]] && return 0
    local marker="# dotfiles: npm global bin (pi)"
    if [[ -f "$HOME/.zprofile" ]] && grep -qF "$marker" "$HOME/.zprofile" 2>/dev/null; then
        export PATH="$ng:$PATH"
        return 0
    fi
    mkdir -p "$(dirname "$HOME/.zprofile")"
    {
        echo ""
        echo "$marker"
        echo "export PATH=\"$ng:\$PATH\""
    } >>"$HOME/.zprofile"
    export PATH="$ng:$PATH"
    print_success "Appended npm global bin to ~/.zprofile: $ng"
}

# Heuristic: directory looks like a pi package (see https://pi.dev/docs/latest/packages — conventional dirs or package.json).
dotpi_child_looks_like_pi_package() {
    local d="$1"
    [[ -d "$d" ]] || return 1
    [[ -f "$d/package.json" ]] || [[ -d "$d/extensions" ]] || [[ -d "$d/skills" ]] || [[ -d "$d/prompts" ]] || [[ -d "$d/themes" ]]
}

# After dotpi + submodules: pi install each immediate child of DOTPI_EXTENSION_ROOT (default ~/.pi/extensions).
# No separate "pi add"; local packages register via "pi install /abs/path" per pi.dev. Set PI_SKIP_DOTPI_EXTENSIONS=1 to skip.
install_pi_packages_from_dotpi_extension_dirs() {
    command -v pi &>/dev/null || return 0
    if [[ -n "${PI_SKIP_DOTPI_EXTENSIONS:-}" ]]; then
        return
    fi
    local root="${DOTPI_EXTENSION_ROOT:-$HOME/.pi/extensions}"
    [[ -d "$root" ]] || return 0

    local -a subs
    subs=("$root"/*(N/))
    local sub apath
    for sub in "${subs[@]}"; do
        [[ -d "$sub" ]] || continue
        [[ "$(basename "$sub")" == .* ]] && continue
        if ! dotpi_child_looks_like_pi_package "$sub"; then
            continue
        fi
        apath="$(builtin cd -q "$sub" && pwd)"
        if [[ -f "$sub/package.json" ]]; then
            print_status "Codespaces: npm install in $apath..."
            (cd "$sub" && npm install) || print_warning "npm install failed in $apath (continuing)."
        fi
        print_status "Codespaces: pi install $apath"
        pi install "$apath" || print_warning "pi install failed: $apath"
    done
}

# Install pi CLI + optional pi packages for every GitHub Codespace (personal dotfiles, not per-repo).
# Set PI_SKIP=1 to disable. Add specs to pi/codespaces-packages.txt (one per line, see https://pi.dev/docs/latest/packages ).
setup_pi_for_codespaces() {
    if [[ -n "${PI_SKIP:-}" ]]; then
        return
    fi
    if ! is_github_codespaces; then
        return
    fi

    if command -v brew &>/dev/null; then
        eval "$(brew shellenv 2>/dev/null)" || true
    fi

    if ! command -v npm &>/dev/null; then
        print_status "Codespaces: installing Node (npm) for pi..."
        brew install node
        eval "$(brew shellenv 2>/dev/null)" || true
    fi

    if ! command -v npm &>/dev/null; then
        print_warning "npm not available; skipping pi install."
        return
    fi

    ensure_npm_global_on_path

    if command -v pi &>/dev/null; then
        print_success "pi already on PATH"
    else
        print_status "Codespaces: npm install -g @mariozechner/pi-coding-agent..."
        npm install -g @mariozechner/pi-coding-agent
    fi

    ensure_npm_global_on_path

    if ! command -v pi &>/dev/null; then
        print_warning "pi not found after npm install -g; check npm global bin on PATH."
        return
    fi

    local pkg_file="$DOTFILES_DIR/pi/codespaces-packages.txt"
    if [[ -f "$pkg_file" ]]; then
        local line spec
        while IFS= read -r line || [[ -n "$line" ]]; do
            spec="$(print -r -- "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/\r$//')"
            [[ -z "$spec" ]] && continue
            [[ "$spec" == \#* ]] && continue
            print_status "Codespaces: pi install $spec"
            pi install "$spec" || print_warning "pi install failed: $spec"
        done <"$pkg_file"
    else
        print_status "Optional pi/codespaces-packages.txt not found — skipping manifest lines."
    fi

    install_pi_packages_from_dotpi_extension_dirs

    print_status "Codespaces: pi list (see ~/.pi/agent/settings.json)"
    pi list || print_warning "pi list failed."
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
        print_status "Dry-run: setup_dotpi_for_codespaces, setup_pi_for_codespaces (Codespaces, before brew), install_homebrew, install_useful_tools, install_oh_my_zsh, install_powerlevel10k, install_zsh_plugins, setup_symlinks, configure_git, setup_shell, configure_macos would be run."
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

    # Codespaces: dotpi + pi before Homebrew optional tools so a brew failure (e.g. 1password-cli on Linux) does not skip pi.
    setup_dotpi_for_codespaces
    setup_pi_for_codespaces

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
    print_success "Dotfiles installation process finished!"
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