![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)
![Shell](https://img.shields.io/badge/shell-bash-blue)

# Scriptman

**Current Version:** 1.0.0

## Table of Contents
- [Quick Start](#quick-start)
- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Direct Execution](#direct-execution)
- [Useful Links](#useful-links)
- [Example](#example)
- [FAQ](#faq)
- [Contribution](#contribution)
- [License](#license)
- [Acknowledgments](#acknowledgments)
- [Contact](#contact)

## Quick Start
To run the `Scriptman` script directly from the internet, use the following command:
```bash
curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/main/Scriptman | bash -s -- ea
```

## Overview
`Scriptman` is a Bash script that allows users to run various scripts directly from the command line without the need to clone or download the entire project. This tool is designed for testing and executing scripts efficiently.

## Features
- **Extract Aliases**: Run the alias extraction script directly from the internet or locally if available.
- **Recover Passwords**: Placeholder for future functionality to recover passwords.
- **User-Friendly Interface**: Simple command-line menu for easy navigation.
- **Command-Line Arguments**: Supports direct execution with options (`ea`, `rp`, `exit`) for streamlined usage.
- **Flexible Execution**: For extracting aliases, you can choose to run the script locally (if `extract_aliases.sh` is present in your directory) or fetch and run it directly from the internet. All arguments (such as `-q` for quiet mode or `-o` for output filename) are supported in both modes.

> **Note:** Scriptman is tested with Bash 4.0+ on Linux and macOS.

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

## Direct Execution
You can also run the script with an option directly:
```bash
curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/main/Scriptman | bash -s -- ea
```
Replace `ea` with `rp` or `exit` as needed.

#### Passing Arguments
You can pass arguments to the extract aliases feature, for example:
```bash
bash Scriptman ea -q -o output.md
```
or
```bash
curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/main/Scriptman | bash -s -- ea -q -o output.md
```
This works for both local and internet execution modes.

## Useful Links

| Description                      | Command                                                                                                   |
|-----------------------------------|-----------------------------------------------------------------------------------------------------------|
| Run Scriptman with arguments      | `curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/main/Scriptman \| bash -s -- ea -q -o output.md` |
| Run extract_aliases.sh directly   | `curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/main/extract-aliases/src/extract_aliases.sh \| bash` |

## Example
```bash
$ bash Scriptman
What do you want to test?
1. Extract Aliases: ea
2. Recover Passwords: rp
3. Exit: exit
Please enter your choice (ea/rp/exit):
```

### Example Output
```text
Aliases have been written to output.md
| Alias | Command |
|-------|---------|
| ll    | ls -la  |
...
```

## FAQ

**Q: What Bash version do I need?**  
A: Scriptman requires Bash 4.0 or higher.

**Q: What if I get a permission error?**  
A: Make sure you have execute permissions: `chmod +x Scriptman`

**Q: How do I report a bug or request a feature?**  
A: Open an issue or start a discussion on GitHub.

## Contribution
Contributions are welcome! If you would like to add features or improve the scripts, please fork the repository and submit a pull request.

## License
This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgments
- Thanks to the contributors and the open-source community for their support.

## Contact
For questions or support, open an issue or join the Discussions tab on GitHub.