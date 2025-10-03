# b6se - Advanced Base Encoding/Decoding Tool

**b6se** is a Bash-based advanced encoding/decoding tool with support for:

- Base64, Base32, Hex encoding/decoding
- Optional compression before encoding
- AES-256-CBC encryption/decryption
- Chunking of large files
- Interactive menu mode
- Serving encoded files over HTTP/HTTPS  
  - Password-protected access  
  - One-time links & download limits  
  - Timeout auto-shutdown
- Remote fetch & decode
- Logging to `logs/b6se.log`

---

## ⚠️ Important Note

You **do not need to run `run_server.py` manually**.  
The `b6se.sh` script automatically launches the server helper when required (for example, when you use the `-s` option to serve files).

This makes the tool seamless to run both locally and via **Scriptman internet execution**.

---

## 🚀 Installation

```bash
cd b6se-tool/src
chmod +x b6se.sh
```

Run directly:

```bash
./b6se.sh -h
```

---

## 📖 Usage Examples

### Basic Encode / Decode

```bash
./b6se.sh -e myfile.txt -o myfile.b64
./b6se.sh -d myfile.b64 -o myfile_decoded.txt
```

---

### Switch Encoding Methods

**Base32:**
```bash
./b6se.sh -e myfile.txt -o myfile.b32 -m base32
./b6se.sh -d myfile.b32 -o myfile_decoded.txt -m base32
```

**Hex:**
```bash
./b6se.sh -e myfile.txt -o myfile.hex -m hex
./b6se.sh -d myfile.hex -o myfile_decoded.txt -m hex
```

---

### Compression + Encoding

```bash
./b6se.sh -e myfolder -o myfolder.tar.b64 --compress
./b6se.sh -d myfolder.tar.b64 -o myfolder.tar.gz
tar -xzf myfolder.tar.gz
```

---

### Encryption + Encoding

```bash
./b6se.sh -e secret.pdf -o secret.enc.b64 -k mypassword
./b6se.sh -d secret.enc.b64 -o secret.pdf -k mypassword
```

---

### Chunking Large Files

```bash
./b6se.sh -e big.iso -o big.iso.b64 --chunk 50M
```
> Decoding requires concatenating and decoding chunks manually.

---

### Serve Encoded File

```bash
./b6se.sh -e myfile.txt -o myfile.b64 -s -p 9000
```
Access: [http://&lt;your-ip&gt;:9000/myfile.b64](http://<your-ip>:9000/myfile.b64)

---

### Serve with Password

```bash
./b6se.sh -e myfile.txt -o myfile.b64 -s -p 8080 -P test123
```

---

### Serve with TLS (HTTPS)

```bash
./b6se.sh -e myfile.txt -o myfile.b64 -s -p 8443 --tls
```
Access: [https://&lt;your-ip&gt;:8443/myfile.b64](https://<your-ip>:8443/myfile.b64)

---

### One-Time Download

```bash
./b6se.sh -e myfile.txt -o myfile.b64 -s -p 9001 --one-time
```

---

### Limit Downloads

```bash
./b6se.sh -e myfile.txt -o myfile.b64 -s -p 9002 --max-downloads 3
```

---

### Timeout Auto-Shutdown

```bash
./b6se.sh -e myfile.txt -o myfile.b64 -s -p 9003 -t 2
```

---

### Fetch & Decode Remote File

```bash
./b6se.sh -f http://example.com/file.b64 -o file.txt
```

---

### Interactive Menu

```bash
./b6se.sh
```

---

### Logs

```bash
cat b6se-tool/logs/b6se.log
```

---

## 📝 Notes

- TLS uses a self-signed certificate (browsers will show a warning).
- Chunked encoding requires manual reassembly for decoding.
- AES-256 encryption is provided via OpenSSL.
- For large files, encoding increases size (~33% for Base64).
- Ensure `openssl`, `tar`, and `curl` are installed.

---