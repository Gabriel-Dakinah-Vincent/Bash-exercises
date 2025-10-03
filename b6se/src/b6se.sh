#!/bin/bash
# b6se - Advanced Base Encoding/Decoding & Server Tool

LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/b6se.log"

usage() {
  cat <<EOF
Usage: b6se.sh [OPTIONS]

Options:
  -e <file>        Encode file
  -d <file>        Decode file
  -m <method>      Method: base64 (default), base32, hex
  -o <out>         Output file name
  --compress       Compress before encoding
  -k <password>    Encrypt/Decrypt with AES-256-CBC
  --chunk <size>   Chunk encoding for large files (e.g., 50M)
  -s               Serve encoded file(s)
  -p <port>        Port for server (default: 8000)
  -P <password>    Password-protect server access
  --one-time       Auto-delete after first download
  --max-downloads N Limit downloads
  -t <mins>        Timeout in minutes (default 10)
  --tls            Enable HTTPS (self-signed cert)
  -f <url>         Fetch remote encoded file and decode
  -h               Help
EOF
}

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

encode_file() {
  local infile="$1" out="$2" method="$3" compress="$4" key="$5" chunk="$6"
  local tmp="$infile"

  [[ "$compress" == "yes" ]] && { tmp="$infile.tar.gz"; tar -czf "$tmp" "$infile"; }

  if [[ -n "$key" ]]; then
    tmp="$tmp.enc"
    openssl enc -aes-256-cbc -salt -pbkdf2 -in "$infile" -out "$tmp" -k "$key"
  fi

  case "$method" in
    base32) base_cmd="base32" ;;
    hex) base_cmd="xxd -p" ;;
    *) base_cmd="base64" ;;
  esac

  if [[ -n "$chunk" ]]; then
    split -b "$chunk" "$tmp" "$out.part."
    for f in "$out.part."*; do
      $base_cmd "$f" > "$f.enc"
      rm "$f"
    done
    log "Chunked encode $infile → $out.part.*"
  else
    $base_cmd "$tmp" > "$out"
    log "Encoded $infile → $out"
  fi
}

decode_file() {
  local infile="$1" out="$2" method="$3" key="$4"
  case "$method" in
    base32) base_cmd="base32 -d" ;;
    hex) base_cmd="xxd -r -p" ;;
    *) base_cmd="base64 -d" ;;
  esac

  $base_cmd "$infile" > "$out"

  if [[ -n "$key" ]]; then
    openssl enc -d -aes-256-cbc -pbkdf2 -in "$out" -out "${out%.enc}" -k "$key"
    out="${out%.enc}"
  fi

  log "Decoded $infile → $out"
}

serve_file() {
  local file="$1" port="$2" pass="$3" onetime="$4" maxdl="$5" timeout="$6" tls="$7"

  log "Serving $file on 0.0.0.0:$port"

  # Locate run_server.py automatically, even if running over the internet
  local server_script
  server_script="$(dirname "$(realpath "$0")")/server/run_server.py"

  if [[ ! -f "$server_script" ]]; then
    echo "[!] run_server.py not found. Exiting." >&2
    exit 1
  fi

  # Launch server automatically, no manual steps needed
  python3 "$server_script" \
    --file "$file" \
    --port "$port" \
    --password "$pass" \
    --one-time "$onetime" \
    --max-downloads "$maxdl" \
    --timeout "$timeout" \
    --tls "$tls" &
    #--tls "$tls" # Uncomment to enable TLS by default
}

fetch_remote() {
  local url="$1" out="$2"
  curl -s "$url" | base64 -d > "$out"
  log "Fetched $url → $out"
}

# Interactive mode
interactive_menu() {
  while true; do
    echo -e "\n=== b6se Interactive Menu ==="
    echo "1. Encode file"
    echo "2. Decode file"
    echo "3. Encode & Serve"
    echo "4. Fetch remote file"
    echo "5. Quit"
    read -p "Choose option: " opt
    case $opt in
      1) read -p "File: " f; read -p "Output: " o; encode_file "$f" "$o" base64 "" "" ;;
      2) read -p "File: " f; read -p "Output: " o; decode_file "$f" "$o" base64 "" ;;
      3) read -p "File: " f; read -p "Port: " p; serve_file "$f" "$p" "" "" "" 10 "" ;;
      4) read -p "URL: " u; read -p "Output: " o; fetch_remote "$u" "$o" ;;
      5) exit 0 ;;
    esac
  done
}

# === Main parser ===
[[ $# -eq 0 ]] && interactive_menu

METHOD="base64"
OUT=""
COMPRESS=""
KEY=""
CHUNK=""
SERVE=""
PORT=8000
PASS=""
ONETIME=""
MAXDL=""
TIMEOUT=10
TLS=""
FETCH=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -e) ACTION="encode"; IN="$2"; shift ;;
    -d) ACTION="decode"; IN="$2"; shift ;;
    -m) METHOD="$2"; shift ;;
    -o) OUT="$2"; shift ;;
    --compress) COMPRESS="yes" ;;
    -k) KEY="$2"; shift ;;
    --chunk) CHUNK="$2"; shift ;;
    -s) SERVE="yes" ;;
    -p) PORT="$2"; shift ;;
    -P) PASS="$2"; shift ;;
    --one-time) ONETIME="yes" ;;
    --max-downloads) MAXDL="$2"; shift ;;
    -t) TIMEOUT="$2"; shift ;;
    --tls) TLS="yes" ;;
    -f) FETCH="$2"; ACTION="fetch"; shift ;;
    -h) usage; exit 0 ;;
    *) echo "Unknown: $1"; usage; exit 1 ;;
  esac
  shift
done

case "$ACTION" in
  encode) encode_file "$IN" "${OUT:-$IN.$METHOD}" "$METHOD" "$COMPRESS" "$KEY" "$CHUNK" ;;
  decode) decode_file "$IN" "${OUT:-$IN.decoded}" "$METHOD" "$KEY" ;;
  fetch) fetch_remote "$FETCH" "${OUT:-out.decoded}" ;;
esac

[[ "$SERVE" == "yes" ]] && serve_file "${OUT:-$IN.$METHOD}" "$PORT" "$PASS" "$ONETIME" "$MAXDL" "$TIMEOUT" "$TLS"