# --------------------------------------------------------------------
# >> MY CUSTOM ALIASES
# --------------------------------------------------------------------

# -- Shell & Config Management --
alias reload="source ~/.zshrc"          # Reload your zsh config
alias zshconfig="code ~/.zshrc"         # Open zsh config in VS Code
alias aliases="code ~/Developer/personal/github.com/AlainS7/dotfiles/xdg/.config/zsh/aliases/general.zsh"
alias functions="code ~/Developer/personal/github.com/AlainS7/dotfiles/xdg/.config/zsh/functions/main_functions.zsh"
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
alias psguser="ps aux | grep -v grep | grep -u" # List processes for a specific user (e.g., psguser username)
alias psg="ps aux | grep -v grep | grep -i" # Find process by name (e.g., psg chrome)
alias killport="fuser -k -n tcp" # Kill process on a port (e.g., killport 3000)

# -- Directory Navigation --
alias desk="cd ~/Desktop"
alias dl="cd ~/Downloads"
alias docs="cd ~/Documents"
alias dev="cd ~/Developer"

# -- Clipboard Management (macOS) --
# Linux: xclip or xsel instead.
# Windows: clip.exe or powershell commands.
alias copyfile="pbcopy <" # Copy file content to clipboard (e.g., copyfile file.txt)
alias copy="pbcopy" # Pipe output to copy to clipboard (e.g., cat file.txt | copy)
alias paste="pbpaste" # Paste content from clipboard