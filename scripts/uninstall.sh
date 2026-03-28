#!/usr/bin/env bash
set -euo pipefail

# ================================================================= #
#                 DOTFILES UNINSTALL SCRIPT                         #
# ================================================================= #
# Removes symlinks created by install.sh and optionally restores    #
# backups from ~/.dotfiles-backup-*                                 #
# ================================================================= #

source "$(dirname "${BASH_SOURCE[0]}")/../lib/utils.sh"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# --- Symlinks created by install.sh ---
SYMLINKS=(
    "$HOME/.zshrc"
    "$HOME/.p10k.zsh"
    "$HOME/.zshenv"
    "$HOME/.gitignore_global"
)

# XDG config symlinks (items inside ~/.config linked by install.sh)
XDG_SOURCE_DIR="$DOTFILES_DIR/xdg/.config"
if [ -d "$XDG_SOURCE_DIR" ]; then
    for config_item in "$XDG_SOURCE_DIR"/*; do
        item_name=$(basename "$config_item")
        SYMLINKS+=("$HOME/.config/$item_name")
    done
fi

remove_symlink() {
    local target="$1"
    if [ -L "$target" ]; then
        local points_to
        points_to=$(readlink "$target")
        # Only remove if it points into our dotfiles directory
        if [[ "$points_to" == "$DOTFILES_DIR"* ]]; then
            rm "$target"
            print_success "Removed symlink: $target -> $points_to"
        else
            print_warning "Skipping $target (points to $points_to, not this dotfiles repo)"
        fi
    elif [ -e "$target" ]; then
        print_warning "Skipping $target (not a symlink)"
    else
        print_status "Already absent: $target"
    fi
}

# --- Remove Git hooks ---
remove_hooks() {
    local hooks_dir="$DOTFILES_DIR/.git/hooks"
    local hook_script="$DOTFILES_DIR/git/hook-reminder.sh"
    for hook in pre-commit pre-push; do
        local hook_path="$hooks_dir/$hook"
        if [ -L "$hook_path" ] && [ "$(readlink "$hook_path")" = "$hook_script" ]; then
            rm "$hook_path"
            print_success "Removed Git hook: $hook"
        fi
    done
}

# --- Restore latest backup ---
restore_backup() {
    local latest_backup
    latest_backup=$(ls -dt "$HOME"/.dotfiles-backup-* 2>/dev/null | head -n1)
    if [ -z "$latest_backup" ]; then
        print_warning "No backup found to restore."
        return
    fi
    print_status "Restoring backed-up files from $latest_backup..."
    for file in "$latest_backup"/*; do
        local basename
        basename=$(basename "$file")
        if cp -r "$file" "$HOME/$basename"; then
            print_success "Restored: $basename"
        else
            print_error "Failed to restore: $basename"
        fi
    done
}

# --- Main ---
print_status "Uninstalling dotfiles symlinks..."

for symlink in "${SYMLINKS[@]}"; do
    remove_symlink "$symlink"
done

remove_hooks

echo ""
read -p "Restore backed-up config files? (y/N): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    restore_backup
fi

print_success "Dotfiles uninstall complete."
print_status "Your shell may behave differently until you reconfigure or reinstall."
