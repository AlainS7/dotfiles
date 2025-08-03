#!/usr/bin/env bash

# This script automates backing up dotfiles to a remote Git repository.

# Source utilities
source "$(dirname "${BASH_SOURCE[0]}")/../lib/utils.sh"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$DOTFILES_DIR" || {
    print_error "Could not change to dotfiles directory: $DOTFILES_DIR"
    exit 1
}

if [ ! -d ".git" ]; then
    print_error "Not a Git repository. Cannot backup dotfiles."
    exit 1
fi

print_status "Backing up dotfiles to remote Git repository..."

git add .

# Check if there are any changes to commit
if git diff --cached --exit-code --quiet; then
    print_success "No changes to commit. Dotfiles are already up to date."
else
    COMMIT_MESSAGE="Automated dotfiles backup: $(date +'%Y-%m-%d %H:%M:%S')"
    git commit -m "$COMMIT_MESSAGE"
    if [ $? -eq 0 ]; then
        print_success "Changes committed locally."
        git push origin main || git push origin master # Adjust branch name as needed
        if [ $? -eq 0 ]; then
            print_success "Dotfiles pushed to remote repository."
        else
            print_error "Failed to push dotfiles to remote repository. Please check your Git configuration and network connection."
        fi
    else
        print_error "Failed to commit changes locally."
    fi
fi
