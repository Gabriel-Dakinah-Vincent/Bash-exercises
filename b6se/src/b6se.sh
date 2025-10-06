#!/usr/bin/env bash
# =========================================================
# b6se.sh — Secure CLI Tool for Compression, Encoding,
# Encryption, and Secure File Sharing
# =========================================================

set -euo pipefail

# ====== PATHS ======
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_DIR="${PROJECT_ROOT}/logs"
LOG_FILE="${LOG_DIR}/b6se.log"
SERVER_SCRIPT="${SCRIPT_DIR}/server/run_server.py"
CONFIG_FILE="${PROJECT_ROOT}/config/config.ini"
HELP_DIR="${PROJECT_ROOT}/help"

mkdir -p "$LOG_DIR" "$HELP_DIR"

# ====== COLORS ======
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"
BOLD="\033[1m"
RESET="\033[0m"

# ====== LOGGING (ROTATION: KEEP 5 LOGS) ======
rotate_logs() {
    for i in 5 4 3 2 1; do
        [ -f "${LOG_FILE}.${i}" ] && mv "${LOG_FILE}.${i}" "${LOG_FILE}.$((i+1))" 2>/dev/null || true
    done
    [ -f "$LOG_FILE" ] && mv "$LOG_FILE" "${LOG_FILE}.1" 2>/dev/null || true
    touch "$LOG_FILE"
}
rotate_logs

log() { echo -e "${CYAN}[INFO]$(date '+ %Y-%m-%d %H:%M:%S')${RESET} $*" | tee -a "$LOG_FILE"; }
success() { echo -e "${GREEN}[SUCCESS]$(date '+ %Y-%m-%d %H:%M:%S')${RESET} $*" | tee -a "$LOG_FILE"; }
warn() { echo -e "${YELLOW}[WARN]$(date '+ %Y-%m-%d %H:%M:%S')${RESET} $*" | tee -a "$LOG_FILE"; }
error() { echo -e "${RED}[ERROR]$(date '+ %Y-%m-%d %H:%M:%S')${RESET} $*" | tee -a "$LOG_FILE" >&2; }
die() { error "$*"; exit 1; }

# ====== CONFIG ======
get_config_value() {
    local section="$1" key="$2"
    grep -A1 "^\[$section\]" "$CONFIG_FILE" | grep "$key" | cut -d'=' -f2 | xargs || true
}

DEFAULT_PORT=$(get_config_value server default_port || echo "8080")

# ====== UTILITIES ======
resolve_path() {
    [[ "$1" = /* ]] && echo "$1" || echo "$(cd "$(dirname "$1")"; pwd)/$(basename "$1")"
}

# ====== CORE ACTIONS ======
compress_file() {
    local target=$(resolve_path "$1")
    local output=$(resolve_path "${2:-${target%/}.tar.gz}")
    log "Compressing $target -> $output"
    tar -czf "$output" -C "$(dirname "$target")" "$(basename "$target")"
    success "Compression complete: $output"
}

decompress_file() {
    local file=$(resolve_path "$1")
    local output_dir=$(resolve_path "${2:-${file%.tar.gz}_extracted}")
    mkdir -p "$output_dir"
    log "Decompressing $file -> $output_dir"
    tar -xzf "$file" -C "$output_dir"
    success "Decompression complete: $output_dir"
}

encode_file() {
    local file=$(resolve_path "$1")
    local output=$(resolve_path "${2:-${file%.*}.b64}")
    base64 "$file" > "$output"
    success "Encoded $file -> $output"
}

decode_file() {
    local file=$(resolve_path "$1")
    local output=$(resolve_path "${2:-${file%.*}}")
    base64 --decode "$file" > "$output"
    success "Decoded $file -> $output"
}

encrypt_file() {
    local file=$(resolve_path "$1")
    local output=$(resolve_path "${2:-${file}.enc}")
    local password="$PASSWORD_FLAG"
    [ -z "$password" ] && die "Password required for encryption (use --password)"
    openssl enc -aes-256-cbc -salt -in "$file" -out "$output" -pass pass:"$password"
    success "Encrypted $file -> $output"
}

decrypt_file() {
    local file=$(resolve_path "$1")
    local output=$(resolve_path "${2:-${file%.enc}}")
    local password="$PASSWORD_FLAG"
    [ -z "$password" ] && die "Password required for decryption (use --password)"
    openssl enc -d -aes-256-cbc -in "$file" -out "$output" -pass pass:"$password"
    success "Decrypted $file -> $output"
}

serve_file() {
    local file=$(resolve_path "$1")
    log "Starting HTTP server for $file on port $DEFAULT_PORT"
    python3 "$SERVER_SCRIPT" --file "$file" >> "$LOG_FILE" 2>&1 &
    SERVER_PID=$!
    warn "Server started (PID $SERVER_PID). Press Ctrl+C to stop."
    trap "warn 'Stopping server...'; kill $SERVER_PID 2>/dev/null; success 'Server stopped'; exit 0" INT TERM
    wait $SERVER_PID
}

# ====== HELP ======
show_help() {
    if [ -f "${HELP_DIR}/usage.txt" ]; then
        echo -e "${BOLD}${BLUE}"
        cat "${HELP_DIR}/usage.txt"
        echo -e "${RESET}"
    else
        echo "Help files missing."
    fi
}

# ====== PASSWORD FLAG RESTORATION ======
PASSWORD_FLAG=""
ARGS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -p|--password)
            shift
            PASSWORD_FLAG="$1"
            shift
            ;;
        *)
            ARGS+=("$1")
            shift
            ;;
    esac
done

set -- "${ARGS[@]}"

# ====== MAIN ENTRY ======
case "${1:-}" in
    -c|--compress) shift; compress_file "$@";;
    -x|--decompress) shift; decompress_file "$@";;
    -e|--encode) shift; encode_file "$@";;
    -d|--decode) shift; decode_file "$@";;
    -E|--encrypt) shift; encrypt_file "$@";;
    -D|--decrypt) shift; decrypt_file "$@";;
    -s|--serve) shift; serve_file "$@";;
    -h|--help|help) show_help;;
    *) echo -e "${YELLOW}💡 Run './b6se.sh --help' for guidance.${RESET}";;
esac