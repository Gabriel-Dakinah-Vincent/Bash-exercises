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
- Secure file serving with username/password authentication
- Graceful server shutdown (Ctrl+C)
- Configurable defaults via `config.ini`
- Log rotation (keep 5 logs)
- Offline help in `help/` directory

---

## ⚙️ Usage

```bash
./src/b6se.sh [command] [options]

Show help:

./src/b6se.sh --help


⸻

🧩 Commands and Examples

Command	Example	Description
Compress	./src/b6se.sh -c file.txt	Compress a file to .tar.gz
	./src/b6se.sh -c folder_name output_archive.tar.gz	Compress a folder to a specified output file
Decompress	./src/b6se.sh -x archive.tar.gz	Extract archive to folder with default name
	./src/b6se.sh -x archive.tar.gz extracted_folder	Extract archive to specified folder
Encode	./src/b6se.sh -e file.txt	Base64 encode a file
	./src/b6se.sh -e file.txt output.b64	Encode to specified output file
Decode	./src/b6se.sh -d file.b64	Decode a Base64 file
	./src/b6se.sh -d file.b64 output.txt	Decode to specified output file
Encrypt	./src/b6se.sh -E file.txt	AES-256 encrypt file using default password
	./src/b6se.sh -E file.txt file.enc	Encrypt to specified output file
Decrypt	./src/b6se.sh -D file.enc	Decrypt file using default password
	./src/b6se.sh -D file.enc output.txt	Decrypt to specified output file
Serve	./src/b6se.sh -s file.txt	Start HTTP server on default port (8080) using default username/password


⸻

🔐 Serving File Test Cases
	1.	Start Server

./src/b6se.sh -s testfile.txt

	•	Access in browser: http://localhost:8080
	•	Login credentials from config.ini:
	•	Username: user
	•	Password: changeme

	2.	Download via curl

curl -u user:changeme http://localhost:8080/testfile.txt -O


⸻

🧪 Comprehensive Test Cases

Compression / Decompression

./src/b6se.sh -c sample.txt
./src/b6se.sh -x sample.tar.gz

Encoding / Decoding

./src/b6se.sh -e sample.txt
./src/b6se.sh -d sample.b64

Encryption / Decryption

./src/b6se.sh -E sample.txt
./src/b6se.sh -D sample.txt.enc

Combined Workflow Test
	1.	Compress → Encode → Encrypt → Serve

./src/b6se.sh -c sample_folder
./src/b6se.sh -e sample_folder.tar.gz
./src/b6se.sh -E sample_folder.tar.gz.b64
./src/b6se.sh -s sample_folder.tar.gz.b64

	•	Access via browser or curl with default credentials.

⸻

🧠 Configuration

Edit config/config.ini to change defaults:

[server]
default_port = 8080
default_username = user
default_password = changeme


⸻

🪵 Logs

All activity is recorded in logs/b6se.log with rotation (keep last 5 logs).

⸻

👷 Author

Developed as part of the Cybersecurity Awareness CLI Initiative at Elevation Institute of Technology, Monrovia.

⸻

✅ Notes
	•	All operations support absolute or relative paths.
	•	Modular usage: each feature can run alone or chained in sequence.
	•	Default authentication required for serving files: username/password from config.ini.
	•	Fully offline help available in help/usage.txt.
