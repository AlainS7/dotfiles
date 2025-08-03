# Zsh Modular Config Directory

This directory contains the modular, XDG-compliant configuration for your Zsh environment. It is designed for clarity, portability, and ease of customization.

## Structure

- **.zshrc** — Main entry point for interactive shells. Sources Oh My Zsh, Powerlevel10k, and loads modular configs.
- **environment/** — Place all environment variable exports here (e.g., `PATH`, `EDITOR`).
- **functions/** — Place custom shell functions here, one per file if desired.
- **aliases/** — Place all your aliases here, organized as you like.
- **.p10k.zsh** — Powerlevel10k theme config (symlinked to `~/.p10k.zsh`).
- **.zshrc.local** — (in `$HOME`) For machine-specific overrides, not tracked in git.

## Usage

- **Edit configs:**
  - Add or edit files in `environment/`, `functions/`, or `aliases/` to customize your shell.
  - Use `.zshrc.local` for settings unique to a single machine.
- **Add plugins:**
  - Add plugin names to the `plugins=(...)` array in `.zshrc`.
  - Custom plugins can be placed in `$ZSH_CUSTOM/plugins/`.
- **Prompt:**
  - Run `p10k configure` or edit `.p10k.zsh` to customize your prompt.

## Best Practices

- Keep `.zshrc` minimal; put logic in modular files.
- Do not commit cache/session files (see `.gitignore`).
- Use `README.md` for onboarding and documentation.

---

For more, see the comments in `.zshrc` and `.zshenv`.
