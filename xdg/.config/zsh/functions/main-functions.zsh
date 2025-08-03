# Custom functions

# Function to create a directory and change into it
mkcd() {
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

```
$piped_input
```"
    else
      echo "No input provided to explain."
      return 1
    fi
  fi
}

# Function to extract any archive
# Usage: extract <file>
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
