# Custom Scripts

These dotfiles include a dedicated `scripts` directory (`./scripts/`) for your personal shell scripts. Any executable script placed in this directory will automatically be available in your shell's `PATH`, meaning you can run them from any directory.

## How it Works

The `install.sh` script ensures that the `./scripts/` directory is added to your shell's `PATH` environment variable. This is configured in `xdg/.config/zsh/environment/main-env.zsh`.

## Usage

1. **Create a new script:** Create a new file (e.g., `my_script.sh`) inside the `./scripts/` directory.
2. **Add a shebang:** Start your script with a shebang line (e.g., `#!/bin/bash` or `#!/usr/bin/env zsh`) to specify the interpreter.
3. **Make it executable:** Run `chmod +x scripts/my_script.sh` to make the script executable.
4. **Run it:** Open a new terminal session (or `source ~/.zshrc`) and you can now run `my_script.sh` from anywhere.

## Included Scripts

### `hello.sh`

This is a simple example script to demonstrate how custom scripts work.

**Purpose:** Outputs a greeting message.

**Usage:**

```sh
hello.sh
```

**Output:**

```plaintext
Hello from your custom scripts directory!
```

### `backup_dotfiles.sh`

This script automates the process of backing up your dotfiles repository to its remote origin. It's designed to be run periodically to keep your dotfiles synchronized and version-controlled.

**Purpose:**

* Stages all changes in your dotfiles repository.
* Commits changes with a timestamped message.
* Pushes committed changes to the `origin` remote (either `main` or `master` branch).

**Usage:**

```sh
backup_dotfiles.sh
```

**Important Notes:**

* **Remote Repository:** This script assumes your dotfiles are managed by Git and have a remote origin configured.
* **Authentication:** Ensure your Git client is configured to authenticate with your remote repository (e.g., via SSH keys or a credential helper).
* **Branch Name:** The script attempts to push to `main` first, then `master`. Adjust if your primary branch has a different name.
