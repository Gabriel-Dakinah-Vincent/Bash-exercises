#!/bin/bash

# Colors

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

# Function to display usage information
usage() {
    echo -e "${YELLOW}Usage:${NC} $0 [${GREEN}-o${NC} ${WHITE}output_file${NC}] [${GREEN}-q${NC}]"
    echo -e "  ${GREEN}-o${NC} ${WHITE}output_file${NC}  Specify the output markdown file name (default: aliases.md)"
    echo -e "  ${GREEN}-q${NC}              Quiet mode, do not open the markdown file"
    exit 1
}

# Default values
output_file="aliases.md"
quiet_mode=false

# Parse command-line options
while getopts ":o:q" opt; do
    case $opt in
        o)
            output_file="$OPTARG"
            ;;
        q)
            quiet_mode=true
            ;;
        *)
            usage
            ;;
    esac
done

# Determine the default shell
default_shell=$(basename "$SHELL")

# Set the configuration file based on the default shell
case "$default_shell" in
    bash)
        config_file="$HOME/.bashrc"
        ;;
    zsh)
        config_file="$HOME/.zshrc"
        ;;
    fish)
        config_file="$HOME/.config/fish/config.fish"
        ;;
    tcsh)
        config_file="$HOME/.cshrc"
        ;;
    ksh)
        config_file="$HOME/.kshrc"
        ;;
    *)
        echo -e "${RED}Error:${NC} Unsupported shell: $default_shell"
        exit 1
        ;;
esac

# Check if the configuration file exists
if [[ ! -f "$config_file" ]]; then
    echo -e "${RED}Error:${NC} ${YELLOW}Configuration file not found:${NC} $config_file"
    exit 1
fi

# Create a markdown file to store aliases
echo "# Aliases" > "$output_file"
echo "| Alias | Command |" >> "$output_file"
echo "|-------|---------|" >> "$output_file"

# Search for aliases in the configuration file and write to markdown
if ! grep -E '^alias ' "$config_file" | while read -r line; do
    alias_name=$(echo "$line" | cut -d'=' -f1 | sed "s/alias //")
    command=$(echo "$line" | cut -d'=' -f2 | sed "s/^'//;s/'$//")
    echo "| $alias_name | $command |" >> "$output_file"
done; then
    echo "No aliases found in $config_file."
    echo "Markdown file $output_file may be empty."
fi

echo -e "${GREEN}Aliases have been written to:${NC} $output_file"

# Open the markdown file if not in quiet mode
if [ "$quiet_mode" = false ]; then
    case "$default_shell" in
        bash | zsh)
            xdg-open "$output_file" &>/dev/null || open "$output_file" &>/dev/null
            ;;
        *)
            echo "Open the file manually: $output_file"
            ;;
    esac
fi