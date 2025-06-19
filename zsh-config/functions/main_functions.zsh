# Custom functions

# Function to create a directory and change into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# can add more functions here later...