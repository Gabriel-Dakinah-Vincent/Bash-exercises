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
    echo -e "${BLUE}Usage${NC}: $0 ${BLUE}[${NC}${GREEN}-o${NC} ${YELLOW}output_file${NC}${BLUE}]${NC} ${BLUE}[${NC}${GREEN}-q${NC}${BLUE}]${NC}"
    echo -e "  ${GREEN}-o${NC} ${YELLOW}output_file${NC}  Specify the output file name (default: ${YELLOW}aliases.md${NC})"
    echo -e "  ${GREEN}-q${NC}              Quiet mode, do not open the output file\n"
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
    bash) config_file="$HOME/.bashrc" ;;
    zsh)  config_file="$HOME/.zshrc" ;;
    fish) config_file="$HOME/.config/fish/config.fish" ;;
    tcsh) config_file="$HOME/.cshrc" ;;
    ksh)  config_file="$HOME/.kshrc" ;;
    *)
        echo -e "${RED}\e[1mError\e[0m:${NC} Unsupported shell: ${RED}$default_shell${NC}"
        exit 1
        ;;
esac

# Check if the configuration file exists
if [[ ! -f "$config_file" ]]; then
    echo -e "${RED}\e[1mError\e[0m:${NC} Configuration file not found: ${RED}$config_file${NC}"
    exit 1
fi

# Detect output extension (default to .md if none)
ext="${output_file##*.}"
if [[ "$output_file" == "$ext" ]]; then
    # No extension provided, default to .md
    ext="md"
    output_file="${output_file}.md"
fi

# Write headers based on extension
case "$ext" in
    md)
        echo "# Aliases" > "$output_file"
        echo "| Alias | Command |" >> "$output_file"
        echo "|-------|---------|" >> "$output_file"
        ;;
    csv)
        echo "Alias,Command" > "$output_file"
        ;;
    html)
        echo "<!DOCTYPE html><html><head><meta charset='UTF-8'><title>Aliases</title>" > "$output_file"
        # Add your style here
        echo "<link rel='stylesheet' type='text/css' href='styles.css'>" >> "$output_file"
        echo "</head><body><table border='1'>" >> "$output_file"
        echo "<tr><th>Alias</th><th>Command</th></tr>" >> "$output_file"
        ;;

    *)
        echo -e "${RED}\e[1mError\e[0m:${NC} Unsupported output extension: ${RED}\e[1m.$ext\e[0m${NC}"
        exit 1
        ;;
esac

# Search for aliases in the configuration file and append
if ! grep -E '^alias ' "$config_file" | while read -r line; do
    alias_name=$(echo "$line" | cut -d'=' -f1 | sed "s/alias //")
    command=$(echo "$line" | cut -d'=' -f2 | sed "s/^'//;s/'$//")

    case "$ext" in
        md)   echo "| $alias_name | $command |" >> "$output_file" ;;
        csv)  echo "\"$alias_name\",\"$command\"" >> "$output_file" ;;
        html) echo "<tr><td>$alias_name</td><td>$command</td></tr>" >> "$output_file" ;;
    esac
done; then
    echo "No aliases found in $config_file."
    echo "Output file $output_file may be empty."
fi

# Close HTML file properly
if [[ "$ext" == "html" ]]; then
    echo "</table></body></html>" >> "$output_file"
fi

echo -e "${GREEN}Aliases have been written to:${NC} ${YELLOW}\e[1m$output_file\e[0m${NC}"

# Open the output file if not in quiet mode
if [ "$quiet_mode" = false ]; then
    case "$default_shell" in
        bash | zsh)
            xdg-open "$output_file" &>/dev/null || open "$output_file" &>/dev/null
            ;;
        *)
            echo "Open the file manually: ${YELLOW}\e[1m$output_file\e[0m${NC}"
            ;;
    esac
fi