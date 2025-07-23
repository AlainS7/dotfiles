#!/bin/zsh
# ~/.zshrc

# Set DOTFILES_DIR if not already set
if [ -z "$DOTFILES_DIR" ]; then
    export DOTFILES_DIR="${HOME}/dotfiles"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
#   ### THE FINAL FIX - ADDED THIS BLOCK ###
#   This makes the `brew` command available for the next section to use.
# =============================================================================
if [ -f "/opt/homebrew/bin/brew" ]; then # Apple Silicon Macs
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f "/usr/local/bin/brew" ]; then # Intel Macs
    eval "$(/usr/local/bin/brew shellenv)"
elif [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then # Linux / Codespaces
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
# =============================================================================

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# This block now correctly runs AFTER the brew command is available.
# Set the custom config directory for zsh
ZSH_CUSTOM_CONFIG_DIR="${DOTFILES_DIR:-$HOME/dotfiles}/xdg/.config/zsh"

# Warn if the custom config directory does not exist
if [ ! -d "$ZSH_CUSTOM_CONFIG_DIR" ]; then
  echo "[.zshrc] WARNING: ZSH_CUSTOM_CONFIG_DIR does not exist: $ZSH_CUSTOM_CONFIG_DIR" >&2
fi

# --- Load environment variables first ---
if [ -d "$ZSH_CUSTOM_CONFIG_DIR/environment" ]; then
  for env_file in "$ZSH_CUSTOM_CONFIG_DIR"/environment/*.zsh; do
    if [ -r "$env_file" ]; then
      source "$env_file"
    fi
  done
  unset env_file
fi

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    z
    sudo
    fzf
    extract
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# -------------------------------------------------------------------
#   Load Custom Configurations
# -------------------------------------------------------------------
# The environment variables block was moved from here to the top.
# Loading aliases and functions after OMZ is correct.
# -------------------------------------------------------------------

# --- Load functions ---
# Check if the functions directory exists
if [ -d "$ZSH_CUSTOM_CONFIG_DIR/functions" ]; then
  # Loop through all files in the 'functions' directory that end with .zsh
  for func_file in "$ZSH_CUSTOM_CONFIG_DIR"/functions/*.zsh; do
    # Source the file if it exists and is readable
    if [ -r "$func_file" ]; then
      source "$func_file"
    fi
  done
  # Unset the variable
  unset func_file
fi

# --- Load aliases ---
# Check if the aliases directory exists before trying to loop
if [ -d "$ZSH_CUSTOM_CONFIG_DIR/aliases" ]; then
  # Loop through all files in the 'aliases' directory that end with .zsh
  for alias_file in "$ZSH_CUSTOM_CONFIG_DIR"/aliases/*.zsh; do
    # Source the file if it exists and is readable
    if [ -r "$alias_file" ]; then
      source "$alias_file"
    fi
  done
  # Unset the variable to keep the shell environment clean
  unset alias_file
fi

# --- Load any other root-level .zsh files (like example.zsh if it contains general configs) ---
# This will source files directly in ~/.zsh-config that are NOT in a subdirectory
# It's good for general configs that don't fit into aliases/functions/environment
if [ -d "$ZSH_CUSTOM_CONFIG_DIR" ]; then
    for misc_file in "$ZSH_CUSTOM_CONFIG_DIR"/*.zsh; do
        # Exclude files already moved to subdirectories, if they somehow linger or are specific
        # This is a basic exclusion; you might need more sophisticated checks if paths overlap.
        # Generally, with a clean move, this isn't strictly necessary for files that *were* moved.
        if [[ "$misc_file" != */aliases/* && "$misc_file" != */functions/* && "$misc_file" != */environment/* && -r "$misc_file" ]]; then
            source "$misc_file"
        fi
    done
    unset misc_file
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/alainsoto/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/alainsoto/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/alainsoto/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/alainsoto/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
