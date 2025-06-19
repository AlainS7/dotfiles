# --------------------------------------------------------------------
# >> MY CUSTOM ALIASES
# --------------------------------------------------------------------

# -- Shell & Config Management --
alias reload="source ~/.zshrc"          # Reload your zsh config
alias zshconfig="code ~/.zshrc"         # Open zsh config in VS Code
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

# -- Git Workflow --
# These build on the 'git' plugin's aliases (like gst, gp, gl, etc.)
alias gco="git checkout"
alias gb="git branch"
alias ga="git add ."
alias gc="git commit -m"
alias glog="git log --oneline --graph --decorate --all" # A much prettier git log

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