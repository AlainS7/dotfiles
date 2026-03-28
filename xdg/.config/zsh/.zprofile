# ~/.zprofile (loaded for login shells when ZDOTDIR is set)
# Keep login shells aligned with interactive shells for Homebrew binaries.
if [ -d "/opt/homebrew/bin" ]; then
  [[ ":$PATH:" != *":/opt/homebrew/bin:"* ]] && export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
elif [ -d "/usr/local/bin" ] && [ -f "/usr/local/bin/brew" ]; then
  [[ ":$PATH:" != *":/usr/local/bin:"* ]] && export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
elif [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
  [[ ":$PATH:" != *":/home/linuxbrew/.linuxbrew/bin:"* ]] && export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi
