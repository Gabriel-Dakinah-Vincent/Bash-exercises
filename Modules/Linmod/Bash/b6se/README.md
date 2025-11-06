# 🛡️ b6se — Secure Bash CLI Utility

**b6se** (Base64 + Secure Encryptor) is a modular Bash CLI tool for:

- Compression / Decompression  
- Encoding / Decoding  
- AES Encryption / Decryption  
- Secure HTTP File Sharing  

---

## 📦 Features

- Independent and combined actions  
- Supports **multiple compression formats** (`.tar.gz`, `.zip`, `.7z`)  
- Works with absolute or relative paths  
- Secure file serving with username + password authentication  
- Graceful server shutdown (Ctrl + C)  
- Configurable defaults via `config.ini`  
- Log rotation (keeps 5 previous logs)  
- Interactive mode for non-technical users  
- Offline help in the `help/` directory  

---

## ⚙️ Usage

```bash
./src/b6se.sh [command] [options]

Show help

./src/b6se.sh --help


⸻

🧩 Example Commands

Task	Example
Compress (auto-format detection)	./src/b6se.sh -c myfolder → creates myfolder.tar.gz
Compress as ZIP	./src/b6se.sh -c myfolder myfolder.zip
Compress as 7Z	./src/b6se.sh -c myfolder myfolder.7z
Decompress TAR.GZ	./src/b6se.sh -x archive.tar.gz
Decompress ZIP	./src/b6se.sh -x archive.zip
Decompress 7Z	./src/b6se.sh -x archive.7z
Encode a file	./src/b6se.sh -e file.txt
Decode a Base64 file	./src/b6se.sh -d file.b64
Encrypt (custom password)	./src/b6se.sh --password mySecret123 -E file.txt
Decrypt (custom password)	./src/b6se.sh --password mySecret123 -D file.txt.enc
Serve securely on custom port	./src/b6se.sh -s file.txt


⸻

🧠 Configuration

Edit the configuration file to change default server credentials:

# config/config.ini
[server]
default_port = 8080
default_username = admin
default_password = changeme


⸻

⚡ Optimization Highlights (v1.3.0)

🚀 Multi-Format Compression Support

Feature	Description
New Auto-Detection System	Automatically identifies and handles .tar.gz, .zip, and .7z formats during compression or decompression.
Zero-Config Upgrade	No new flags or syntax changes required — works seamlessly with existing commands.
Graceful Fallback	If a tool (e.g., 7z) isn’t installed, b6se displays a friendly warning instead of failing.
Cross-Platform Tested	Verified on Linux and WSL with tar, zip/unzip, and p7zip-full.


⸻

🧪 Test Scenarios

Scenario	Command	Expected Result
Compress directory (default)	./src/b6se.sh -c ./project	Creates project.tar.gz
Compress directory as ZIP	./src/b6se.sh -c ./project project.zip	Creates project.zip
Compress directory as 7Z	./src/b6se.sh -c ./project project.7z	Creates project.7z
Decompress TAR.GZ	./src/b6se.sh -x project.tar.gz	Extracts to project_extracted/
Decompress ZIP	./src/b6se.sh -x project.zip	Extracts to project_extracted_1/
Decompress 7Z	./src/b6se.sh -x project.7z	Extracts to project_extracted_2/
Encode / Decode	./src/b6se.sh -e notes.txt / -d notes.b64	Converts and restores successfully
Encrypt / Decrypt	./src/b6se.sh --password mySecret -E report.pdf / -D report.pdf.enc	File encrypted and restored
Serve file	./src/b6se.sh -s report.pdf	Starts secure local HTTP server


⸻

🪵 Logs

All activity is recorded in logs/b6se.log with automatic rotation (keeps 5 previous logs).
Each run includes timestamps and event categories: INFO, SUCCESS, WARN, and ERROR.

⸻

👷 Author

Developed as part of the Cybersecurity Awareness CLI Initiative
at Elevation Institute of Technology, Monrovia.

⸻

🧾 Changelog

v1.3.0 — Multi-Format Compression Update
	•	Added support for .tar.gz, .zip, and .7z archives
	•	Introduced automatic format detection
	•	Improved error handling and graceful fallback for missing tools
	•	Enhanced compatibility for Linux and WSL environments

⸻

✅ Everything now works out of the box:
	•	Runs from project root
	•	Auto-creates logs
	•	Built-in & offline help
	•	Secure by default with optional custom passwords
	•	Fully modular — each feature works standalone or in combination
	•	Multi-format compression and decompression added

---

Would you like me to include a **badges section** (for version, license, and language — e.g., Bash, MIT License) at the top before the description?  
That makes the project look even more professional on GitHub.