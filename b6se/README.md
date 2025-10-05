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
- Secure file serving with password auth
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
Encode	./src/b6se.sh -e file.txt
Encrypt	./src/b6se.sh -E file.txt --password secret
Serve	./src/b6se.sh -s file.txt --port 9090


⸻

🧠 Configuration

Edit config/config.ini to change default server port and password.

⸻

🪵 Logs

All activity is recorded in logs/b6se.log with rotation (5 logs).

⸻

👷 Author

Developed as part of the Cybersecurity Awareness CLI Initiative at Elevation Institute of Technology, Monrovia.

---

✅ **Everything now works out of the box**:
- You can run it from project root.
- It auto-creates logs.
- You have built-in and offline help.
- Fully modular (each feature can work alone or chained).
