```markdown
# Scriptman

## Quick Start
To run the `Scriptman` script directly from the internet, use the following command:
```bash
curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/main/Scriptman | bash -s -- ea
```

## Overview
`Scriptman` is a Bash script that allows users to run various scripts directly from the command line without the need to clone or download the entire project. This tool is designed for testing and executing scripts efficiently.

## Features
- **Extract Aliases**: Run the alias extraction script directly from the internet.
- **Recover Passwords**: Placeholder for future functionality to recover passwords.
- **User-Friendly Interface**: Simple command-line menu for easy navigation.
- **Command-Line Arguments**: Supports direct execution with options (`ea`, `rp`, `exit`) for streamlined usage.

## Installation
No installation is required. You can run the script directly in your terminal.

## Usage
1. Open your terminal.
2. Run the script using:
   ```bash
   bash Scriptman
   ```
3. Follow the prompts to select an option:
   - Type `ea` to extract aliases.
   - Type `rp` to recover passwords (not yet implemented).
   - Type `exit` to exit the script.

### Direct Execution
You can also run the script with an option directly:
```bash
curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/main/Scriptman | bash -s -- ea
```
Replace `ea` with `rp` or `exit` as needed.

## Example
```bash
$ bash Scriptman
What do you want to test?
1. Extract Aliases: ea
2. Recover Passwords: rp
3. Exit: exit
Please enter your choice (ea/rp/exit):
```

## Contribution
Contributions are welcome! If you would like to add features or improve the scripts, please fork the repository and submit a pull request.

## License
This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgments
- Thanks to the contributors and the open-source community for their support.
``` 