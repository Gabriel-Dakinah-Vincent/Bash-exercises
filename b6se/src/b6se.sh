#!/usr/bin/env bash
# b6se.sh — Modular Secure Encode/Decode/Compression/Encryption Tool
set -euo pipefail
IFS=$'\n\t'

# ======== LOGGING AND HELPERS ========
log() { echo "[INFO] $*"; }
die() { echo "[ERROR] $*" >&2; exit 1; }

usage() {
    cat <<EOF
Usage: $0 <command> [options]

Commands:
  encode          Encode a file (optionally compress & encrypt)
  decode          Decode a file (optionally decrypt & decompress)
  serve           Serve a file over HTTPS (using run_server.py)
  help            Show this message

Examples:
  $0 encode --file report.txt --method base64 --compress --encrypt --pass secret
  $0 decode --file report.txt.base64.enc.aes --method base64 --decrypt --decompress --pass secret
  $0 serve  --file data.enc --port 8443 --password secret --one-time

EOF
}

# ======== CORE FILE OPERATIONS ========

compress_file() {
    local infile="$1"
    local outfile="${infile}.tar.gz"
    tar -czf "$outfile" -C "$(dirname "$infile")" "$(basename "$infile")"
    echo "$outfile"
}

decompress_file() {
    local infile="$1"
    local outdir="${2:-./extracted}"
    mkdir -p "$outdir"
    tar -xzf "$infile" -C "$outdir"
    echo "$outdir"
}

encode_file() {
    local infile="$1" method="$2"
    local outfile="${infile}.${method}.enc"
    case "$method" in
        base64) base64 "$infile" > "$outfile" ;;
        base32) base32 "$infile" > "$outfile" ;;
        hex) xxd -p "$infile" > "$outfile" ;;
        *) die "Unsupported encoding method: $method" ;;
    esac
    echo "$outfile"
}

decode_file() {
    local infile="$1" method="$2"
    local outfile="${infile}.${method}.dec"
    case "$method" in
        base64) base64 -d "$infile" > "$outfile" ;;
        base32) base32 -d "$infile" > "$outfile" ;;
        hex) xxd -r -p "$infile" > "$outfile" ;;
        *) die "Unsupported decoding method: $method" ;;
    esac
    echo "$outfile"
}

encrypt_file() {
    local infile="$1" pass="$2"
    local outfile="${infile}.aes"
    openssl enc -aes-256-cbc -pbkdf2 -salt -in "$infile" -out "$outfile" -pass pass:"$pass"
    echo "$outfile"
}

decrypt_file() {
    local infile="$1" pass="$2"
    local outfile="${infile%.aes}.dec"
    openssl enc -d -aes-256-cbc -pbkdf2 -in "$infile" -out "$outfile" -pass pass:"$pass"
    echo "$outfile"
}

# ======== COMPOSABLE WORKFLOWS ========

process_encode() {
    local infile="$1"
    local method="${2:-base64}"
    local compress="${3:-false}"
    local encrypt="${4:-false}"
    local pass="${5:-}"

    local current="$infile"

    if [ "$compress" = true ]; then
        log "Compressing..."
        current=$(compress_file "$current")
    fi

    log "Encoding ($method)..."
    current=$(encode_file "$current" "$method")

    if [ "$encrypt" = true ]; then
        [ -n "$pass" ] || die "Password required for encryption"
        log "Encrypting..."
        current=$(encrypt_file "$current" "$pass")
    fi

    log "✅ Final output: $current"
}

process_decode() {
    local infile="$1"
    local method="${2:-base64}"
    local decrypt="${3:-false}"
    local decompress="${4:-false}"
    local pass="${5:-}"

    local current="$infile"

    if [ "$decrypt" = true ]; then
        [ -n "$pass" ] || die "Password required for decryption"
        log "Decrypting..."
        current=$(decrypt_file "$current" "$pass")
    fi

    log "Decoding ($method)..."
    current=$(decode_file "$current" "$method")

    if [ "$decompress" = true ]; then
        log "Decompressing..."
        current=$(decompress_file "$current")
    fi

    log "✅ Final output directory: $current"
}

# ======== SERVER ========

serve_file() {
    local file=""
    local port="8080"
    local password=""
    local one_time=false
    local max_downloads=0
    local tls=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --file) file="$2"; shift 2 ;;
            --port) port="$2"; shift 2 ;;
            --password) password="$2"; shift 2 ;;
            --one-time) one_time=true; shift ;;
            --max) max_downloads="$2"; shift 2 ;;
            --tls) tls=true; shift ;;
            *) die "Unknown option: $1" ;;
        esac
    done

    [ -f "$file" ] || die "File not found: $file"

    log "Starting Python HTTPS server..."
    python3 run_server.py --file "$file" --port "$port" \
        --password "$password" \
        $( [ "$one_time" = true ] && echo "--one-time" ) \
        $( [ "$tls" = true ] && echo "--tls" ) \
        $( [ "$max_downloads" -gt 0 ] && echo "--max $max_downloads" )
}

# ======== MAIN COMMAND HANDLER ========

cmd="${1:-help}"
shift || true

case "$cmd" in
    encode)
        infile=""; method="base64"; compress=false; encrypt=false; pass=""
        while [[ $# -gt 0 ]]; do
            case "$1" in
                --file) infile="$2"; shift 2 ;;
                --method) method="$2"; shift 2 ;;
                --compress) compress=true; shift ;;
                --encrypt) encrypt=true; shift ;;
                --pass) pass="$2"; shift 2 ;;
                *) die "Unknown option: $1" ;;
            esac
        done
        [ -n "$infile" ] || die "--file required"
        process_encode "$infile" "$method" "$compress" "$encrypt" "$pass"
        ;;
    decode)
        infile=""; method="base64"; decrypt=false; decompress=false; pass=""
        while [[ $# -gt 0 ]]; do
            case "$1" in
                --file) infile="$2"; shift 2 ;;
                --method) method="$2"; shift 2 ;;
                --decrypt) decrypt=true; shift ;;
                --decompress) decompress=true; shift ;;
                --pass) pass="$2"; shift 2 ;;
                *) die "Unknown option: $1" ;;
            esac
        done
        [ -n "$infile" ] || die "--file required"
        process_decode "$infile" "$method" "$decrypt" "$decompress" "$pass"
        ;;
    serve)
        serve_file "$@"
        ;;
    help|--help|-h)
        usage
        ;;
    *)
        die "Unknown command: $cmd"
        ;;
esac