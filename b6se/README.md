# b6se — Secure Modular Encode/Decode/Serve Tool

A modular, composable CLI for:
- 🔐 Encryption / Decryption (AES-256)
- 📦 Compression / Decompression (tar.gz)
- 🧬 Encoding / Decoding (base64/base32/hex)
- 🌍 Secure HTTPS one-time file serving

---

## 🚀 Quick Examples

### Encode + Compress + Encrypt
```bash
./b6se.sh encode --file report.txt --method base64 --compress --encrypt --pass secret123

Decode + Decrypt + Decompress

./b6se.sh decode --file report.txt.base64.enc.aes --method base64 --decrypt --decompress --pass secret123

Serve file over HTTPS (one-time download)

./b6se.sh serve --file encoded.aes --port 8443 --password secret123 --one-time --tls

Individual Operations

./b6se.sh encode --file data.txt --method hex
./b6se.sh compress --file notes.txt
./b6se.sh encrypt --file notes.tar.gz --pass mypass


⸻

🧠 Notes
	•	Requires: bash, tar, openssl, python3, base64, xxd.
	•	Files are processed in chained order: Compress → Encode → Encrypt.
	•	Decryption reverses that chain: Decrypt → Decode → Decompress.
