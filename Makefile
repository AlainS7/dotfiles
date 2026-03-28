SHELL := /bin/bash
.DEFAULT_GOAL := help

DOTFILES_DIR := $(shell cd "$(dirname "$(realpath $(lastword $(MAKEFILE_LIST)))")" && pwd)

.PHONY: help install test lint update backup uninstall

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Run the full dotfiles installation
	@zsh install.sh

dry-run: ## Preview installation without making changes
	@zsh install.sh --dry-run

test: ## Run all Bats tests
	@bats tests/

lint: ## Run ShellCheck on all shell scripts
	@echo "Linting shell scripts with ShellCheck..."
	@find . -name '*.sh' -not -path './.git/*' -exec shellcheck -x {} +
	@echo "Linting zsh files with ShellCheck (posix + zsh extensions)..."
	@find . -name '*.zsh' -not -path './.git/*' -not -name '.p10k.zsh' -exec shellcheck -x --shell=bash {} + || true
	@echo "Lint complete."

update: ## Pull latest changes and re-run install
	@git pull --rebase origin "$$(git rev-parse --abbrev-ref HEAD)"
	@zsh install.sh

backup: ## Backup dotfiles to remote repository
	@bash scripts/backup-dotfiles.sh

uninstall: ## Remove dotfiles symlinks (restores backups if available)
	@bash scripts/uninstall.sh

restore: ## Restore most recent backup
	@zsh install.sh --restore-backup

readme: ## Regenerate README.md
	@zsh install.sh --generate-readme
