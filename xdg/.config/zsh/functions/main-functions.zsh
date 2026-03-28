# Custom functions

# Function to create a directory and change into it
mkcd() {
  if [ -z "$1" ]; then
    echo "Usage: mkcd <directory>" >&2
    return 1
  fi
  mkdir -p "$1" && cd "$1"
}

# Function to explain the output of a command using Gemini
explain() {
  if [ -z "$@" ]; then
    echo "Usage: <command> | explain"
    echo "       explain <text_to_explain>"
    return 1
  fi

  if [ -t 0 ]; then # Check if input is from a terminal (i.e., not piped)
    # If no pipe, assume arguments are the text to explain
    gemini "Explain this: $@"
  else
    # If piped, read from stdin
    local piped_input=$(cat)
    if [ -n "$piped_input" ]; then
      gemini "Explain the following output: 

\`\`\`
$piped_input
\`\`\`"
    else
      echo "No input provided to explain."
      return 1
    fi
  fi
}

# Note: The 'extract' function is provided by the Oh My Zsh 'extract' plugin.
# It supports more formats than a custom implementation. See: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/extract
