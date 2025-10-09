# Scriptman  
**Current Version:** 1.2.0  
**Author:** Gabriel Dakinah Vincent  
**License:** MIT  

---

## Table of Contents
- [Quick Start](#quick-start)
- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Direct Execution](#direct-execution)
- [Passing Arguments](#passing-arguments)
- [Useful Links](#useful-links)
- [Examples](#examples)
- [FAQ](#faq)
- [Contribution](#contribution)
- [License](#license)
- [Acknowledgments](#acknowledgments)
- [Contact](#contact)
- [Changelog](#changelog)

---

## Quick Start

Run Scriptman directly from the internet with one command:

```bash
curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se/Scriptman | bash -s -- --help

⸻

Overview

Scriptman is a modular Bash-based script launcher designed to execute and test other scripts directly from the internet — no need to clone repositories.

With the b6se.sh integration, it now supports secure file operations, configuration management, and remote command execution — all through the same unified CLI interface.

⸻

Features

Core Features
	•	🧩 Modular Execution – Run supported scripts (extract-aliases, b6se, etc.) locally or remotely.
	•	🔐 b6se Integration – Secure file compression, encryption, and HTTP file serving.
	•	⚙️ Dynamic Configuration – Automatically generates missing config files.
	•	📁 Smart Directories – Uses safe, writable directories instead of /home.
	•	💬 Interactive & Non-interactive – Supports both menu-driven and direct argument execution.
	•	🌐 Remote Testing Ready – Fully works with curl | bash for live testing or CI/CD pipelines.

⸻

Installation

No installation is required — everything runs directly in your shell.

To make it permanent:

sudo curl -s -o /usr/local/bin/Scriptman https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se/Scriptman
sudo chmod +x /usr/local/bin/Scriptman

Now you can use:

Scriptman ea -q -o output.html
Scriptman rp


⸻

Usage

Interactive Mode

Run without arguments to open the CLI menu:

bash Scriptman

Then select:
	•	ea → Extract Aliases
	•	rp → Recover Passwords (coming soon)
	•	b6se → Launch Secure CLI
	•	exit → Quit Scriptman

Example Menu:

What do you want to test?
1. Extract Aliases: ea
2. Recover Passwords: rp
3. Run b6se.sh: b6se
4. Exit: exit
Please enter your choice (ea/rp/b6se/exit):


⸻

Direct Execution

Run Scriptman directly from GitHub with arguments:

curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se/Scriptman | bash -s -- ea -h

curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se/Scriptman | bash -s -- rp --help

curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se/Scriptman | bash -s -- sudo b6se --version

⸻

Passing Arguments

Local Execution

bash Scriptman ea -q -o aliases.md
bash Scriptman b6se --encrypt file.txt --password mySecret123

Remote Execution

curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se/Scriptman | bash -s -- ea -q -o aliases.md
curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se/Scriptman | bash -s -- rp 
curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se/Scriptman | sudo bash -s -- b6se --encrypt file.txt --password mySecret123


⸻

Useful Links

Description	Command
Run Scriptman with Extract Aliases	`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se/Scriptman | bash -s -- ea --help

Run Extract Aliases directly	`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se/extract-aliases/src/extract_aliases.sh | bash -s -- --help

Run Scriptman with Secure CLI Utility	`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se/Scriptman | bash -s -- sudo b6se --help

Run b6se Secure CLI	`curl -s https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se/b6se/src/b6se.sh | sudo bash -s -- --help
⸻

Examples

Example 1: Extract Aliases

bash Scriptman ea

Output:

Aliases have been written to output.md
| Alias | Command |
|-------|----------|
| ll    | ls -la   |


⸻

Example 2: Run b6se Secure CLI

bash Scriptman b6se --serve ~/Documents

Output:

[INFO] 2025-10-07 20:30:26 Starting HTTP server on port 8080
[INFO] Server started (PID 3495)
Press Ctrl+C to stop


⸻

FAQ

Q: What Bash version is required?
A: Bash 4.0 or higher.

Q: What if I get a “Permission denied” error?
A: Run with a writable path (like ~/Documents) or use sudo.

Q: Does it work without cloning?
A: Yes — all commands work remotely via curl | bash.

Q: Can I customize config values?
A: Yes — edit config/config.ini after the first run.

⸻

Contribution

Contributions are welcome!
Fork the repository and submit a pull request with a clear description of changes.
Please follow the existing file and folder structure for consistency.

⸻

License

This project is licensed under the MIT License.
See the LICENSE file for full details.

⸻

Acknowledgments
	•	Thanks to the open-source community for their continuous support.
	•	Inspired by real-world Bash automation and DevSecOps practices.

⸻

Contact

For questions or support:
📧 Open an Issue or join the Discussions tab on GitHub.
🧠 Author: Gabriel Dakinah Vincent

⸻

Changelog

Version 1.2.0
	•	Added automatic config generation for b6se.sh
	•	Improved serve handling and graceful exit
	•	Added dynamic working directory logic
	•	Unified Scriptman and b6se integration
	•	Enhanced README.md formatting and clarity
	•	Tested for both local and remote execution

⸻