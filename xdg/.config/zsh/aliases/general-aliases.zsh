# --------------------------------------------------------------------
# >> MY CUSTOM ALIASES
# --------------------------------------------------------------------

# -- Shell & Config Management --
alias reload="source ~/.zshrc"          # Reload your zsh config
alias zshconfig="code ~/.zshrc"         # Open zsh config in VS Code
alias aliases='code "$DOTFILES_DIR/xdg/.config/zsh/aliases/general-aliases.zsh"'
alias functions='code "$DOTFILES_DIR/xdg/.config/zsh/functions/main-functions.zsh"'
alias p10kconfig="p10k configure"       # Re-run Powerlevel10k wizard


# Alias to manage dotfiles using a bare repository
alias dotgit='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# -- Navigation & File Management --
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ls="ls -G"                        # Add colors to ls
alias l="ls -lFha"                      # List all files in long format
alias ll="ls -l"                        # List files in long format
alias la="ls -a"                        # List all files, including hidden
alias c="clear"                          # Clear the terminal screen

# -- Git Workflow --
# These build on the 'git' plugin's aliases (like gst, gp, gl, gcl etc.)
alias gco="git checkout"
alias gb="git branch"
alias ga="git add ."
alias gc="git commit -m"
alias glog="git log --oneline --graph --decorate --all" # Much prettier git log
alias glo="git log --oneline --decorate --graph"

# -- Additional Git Aliases --
# Status & Diff
alias gs="git status -sb" # (gst in OMZ git plugin)
alias gd="git diff"       # Show changes
alias gds="git diff --staged" # Show staged changes
# Staging/Unstaging
alias gau="git add -u" # Quickly stages modified and deleted files (but not new untracked files).
alias grh="git reset HEAD" # Unstages changes you’ve added with git add.

# -- System & Process Management --
alias h="history"
alias myip="curl ifconfig.me"           # Get your public IP address
alias ports="netstat -tulpn | grep LISTEN" # See all open ports

# -- Development (examples, adapt to your needs) --
alias ni="npm install"
alias nrd="npm run dev"
alias dc="docker-compose"
alias dcu="docker-compose up -d"
alias dcd="docker-compose down"
alias pi="pnpm install"
alias prd="pnpm run dev"

# -- Safety Aliases --
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# -- Path Viewing --
alias path='echo -e ${PATH//:/\\n}'

# -- Disk Usage --
alias du="du -h"
alias df="df -h"

# -- Process Management --
alias psgall="ps aux" # List all processes
psguser() { ps -u "${1:-$USER}" ; }    # List processes for a specific user (e.g., psguser username)
alias psg="ps aux | grep -v grep | grep -i" # Find process by name (e.g., psg chrome)
if [[ "$OSTYPE" == darwin* ]]; then
  alias killport='lsof -ti tcp:$1 | xargs kill -9' # Kill process on a port (macOS)
else
  alias killport="fuser -k -n tcp" # Kill process on a port (Linux)
fi

# -- Directory Navigation --
alias desk="cd ~/Desktop"
alias dl="cd ~/Downloads"
alias docs="cd ~/Documents"
alias dev="cd ~/Projects/Developer"

# -- Clipboard Management --
# Automatically uses pbcopy/pbpaste on macOS or xclip on Linux.
if [[ "$OSTYPE" == darwin* ]]; then
  alias copyfile="pbcopy <"   # Copy file content to clipboard (e.g., copyfile file.txt)
  alias copy="pbcopy"         # Pipe output to clipboard (e.g., cat file.txt | copy)
  alias paste="pbpaste"       # Paste content from clipboard
elif command -v xclip &>/dev/null; then
  alias copyfile="xclip -selection clipboard <"
  alias copy="xclip -selection clipboard"
  alias paste="xclip -selection clipboard -o"
elif command -v xsel &>/dev/null; then
  alias copyfile="xsel --clipboard --input <"
  alias copy="xsel --clipboard --input"
  alias paste="xsel --clipboard --output"
fi