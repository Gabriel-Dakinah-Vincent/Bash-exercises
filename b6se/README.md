# b6se — Secure Bash CLI Utility

**b6se** (Base64 + Secure Encryptor) is a modular Bash CLI tool for:
- Compression / Decompression  
- Encoding / Decoding  
- AES Encryption / Decryption  
- Secure HTTP File Sharing  

---

## 📦 Features
- Independent and combined actions  
- Works with absolute or relative paths  
- Secure file serving with username + password authentication  
- Graceful server shutdown (Ctrl+C)  
- Configurable defaults via `config.ini`  
- Log rotation (keep 5 logs)  
- Interactive mode for non-technical users  
- Offline help in `help/` directory  

---

## ⚙️ Usage

```bash
./src/b6se.sh [command] [options]

Run interactively:

./src/b6se.sh --interactive

Show help:

./src/b6se.sh --help


⸻

🧩 Example Commands

Task	Example
Compress	./src/b6se.sh -c file.txt
Decompress	./src/b6se.sh -x file.txt.tar.gz
Encode	./src/b6se.sh -e file.txt
Decode	./src/b6se.sh -d file.b64
Encrypt (default password)	./src/b6se.sh -E file.txt
Encrypt (custom password)	./src/b6se.sh --password mySecret123 -E file.txt
Decrypt (default password)	./src/b6se.sh -D file.txt.enc
Decrypt (custom password)	./src/b6se.sh --password mySecret123 -D file.txt.enc
Serve securely on custom port	./src/b6se.sh -s file.txt


⸻

🧠 Configuration

Edit config/config.ini to change the default server credentials:

[server]
default_port = 8080
default_username = admin
default_password = changeme

You can override the password dynamically with the --password flag for encryption, decryption, or secure file serving.

⸻

🧪 Test Scenarios

Scenario	Command	Expected Result
Compress a directory	./src/b6se.sh -c ./project	Creates project.tar.gz
Decompress an archive	./src/b6se.sh -x project.tar.gz	Extracts files to project_extracted/
Encode a file	./src/b6se.sh -e notes.txt	Creates notes.b64
Decode a Base64 file	./src/b6se.sh -d notes.b64	Restores notes.txt
Encrypt with default password	./src/b6se.sh -E report.pdf	Creates report.pdf.enc
Encrypt with custom password	./src/b6se.sh --password mySecret -E report.pdf	Creates report.pdf.enc
Decrypt with default password	./src/b6se.sh -D report.pdf.enc	Restores report.pdf
Serve file securely	./src/b6se.sh -s report.pdf	Starts local HTTP file server
Stop server safely	Ctrl + C	Server shuts down gracefully


⸻

🪵 Logs

All activity is recorded in logs/b6se.log with automatic rotation (keeps 5 previous logs).
Each run includes timestamps and event categories: INFO, SUCCESS, WARN, and ERROR.

⸻

👷 Author

Developed as part of the Cybersecurity Awareness CLI Initiative
at Elevation Institute of Technology, Monrovia.

⸻

✅ Everything now works out of the box:
	•	Runs from project root
	•	Auto-creates logs
	•	Built-in & offline help
	•	Secure by default with optional custom passwords
	•	Fully modular — each feature works standalone or in combination

---