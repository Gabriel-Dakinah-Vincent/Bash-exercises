#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 [-o output_file] [-q]"
    echo "  -o output_file  Specify the output markdown file name (default: aliases.md)"
    echo "  -q              Quiet mode, do not open the markdown file"
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
        echo "Unsupported shell: $default_shell"
        exit 1
        ;;
esac

# Check if the configuration file exists
if [[ ! -f "$config_file" ]]; then
    echo "Configuration file not found: $config_file"
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

echo "Aliases have been written to $output_file"

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