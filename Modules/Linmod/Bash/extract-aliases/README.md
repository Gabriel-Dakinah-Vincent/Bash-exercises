```markdown
# Extract Aliases

A simple Bash script that extracts shell aliases from the default shell configuration file and outputs them to a Markdown file in a structured format.
It extracts user-defined shell aliases from your shell configuration file and outputs them in your choice of Markdown, CSV, or HTML format, all in a structured table.
## Try Before You Clone

You can test this script without cloning the repository by running the following command:

```bash
curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Scriptmanem/refs/heads/main/extract-aliases/src/extract_aliases.sh | bash
```
## Features

- **Automatic Detection**: Identifies the default shell (Bash, Zsh, Fish, etc.) and uses the appropriate configuration file.
- **Alias Extraction**: Extracts all user-defined aliases and their corresponding commands.
- **Custom Output**: Allows users to specify a custom output filename for the generated Markdown file.
- **Quiet Mode**: Option to suppress auto-opening of the Markdown file after generation.
- **Markdown Formatting**: Outputs aliases in a well-structured Markdown table for easy readability.

## Usage

1. **Clone the repository**:
    ```bash
    git clone https://github.com/Gabriel-Dakinah-Vincent/Scriptmanem.git
    cd extract-aliases
    ```

2. **Make the script executable**:
    ```bash
    chmod +x src/extract_aliases.sh
    ```

3. **Run the script**:
    ```bash
    ./src/extract_aliases.sh
    ```

4. **Options**:
    - Specify a custom output filename:
      ```bash
      ./src/extract_aliases.sh -o my_aliases.md
      ```
    - Run in quiet mode (do not open the Markdown file):
      ```bash
      ./src/extract_aliases.sh -q
      ```

## Example


After running the script, the output will be saved in your chosen format (Markdown, CSV, or HTML). Example Markdown output:

```markdown
# Aliases
| Alias | Command        |
|-------|----------------|
| ll    | ls -la        |
| gs    | git status     |
```

Example CSV output:
```csv
Alias,Command
ll,ls -la
gs,git status
```

Example HTML output:
```html
<table border='1'>
    <tr><th>Alias</th><th>Command</th></tr>
    <tr><td>ll</td><td>ls -la</td></tr>
    <tr><td>gs</td><td>git status</td></tr>
</table>
```

## Testing

This project includes a basic test suite. To run the tests, execute:

```bash
chmod +x tests/test_extract_aliases.sh
./tests/test_extract_aliases.sh
```

## Contributing

Contributions are welcome! Here’s how you can contribute:

1. Fork the repository.
2. Create a new feature branch:
    ```bash
    git checkout -b feature/my-feature
    ```
3. Make your changes and commit them:
    ```bash
    git commit -m 'Add my feature'
    ```
4. Push to the branch:
    ```bash
    git push origin feature/my-feature
    ```
5. Open a pull request.

Please ensure your code follows the existing style and includes tests for new features.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Acknowledgments

- Inspired by various shell scripting practices.
- Thanks to the open-source community for contributing to Bash scripting knowledge.

For any questions or issues, feel free to open an issue in the GitHub repository.
