# Launch zsh automatically for interactive shells
if [ -t 1 ] && [ "$SHELL" != "/usr/bin/zsh" ] && [ -z "$ZSH_AUTOLAUNCHED" ]; then
  export ZSH_AUTOLAUNCHED=1
  exec zsh
fi