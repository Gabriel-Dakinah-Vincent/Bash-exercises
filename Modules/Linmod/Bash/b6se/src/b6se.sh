#!/usr/bin/env bash
# 
# b6se.sh — Secure CLI Tool for Compression, Encoding,
# Encryption, and Secure File Sharing
# Optimized Version with Multi-Format Compression + Checksum Verification
#

set -euo pipefail

# PATHS
SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]:-${0}}")" >/dev/null 2>&1 && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_DIR="${PROJECT_ROOT}/logs"
HELP_DIR="${PROJECT_ROOT}/help"
CONFIG_DIR="${PROJECT_ROOT}/config"
CONFIG_FILE="${CONFIG_DIR}/config.ini"
SERVER_SCRIPT="${SCRIPT_DIR}/server/run_server.py"
LOG_FILE="${LOG_DIR}/b6se.log"

# COLORS
RED="\033[31m"; GREEN="\033[32m"; YELLOW="\033[33m"; BLUE="\033[34m"
CYAN="\033[36m"; BOLD="\033[1m"; RESET="\033[0m"

mkdir -p "$LOG_DIR" "$HELP_DIR" "$CONFIG_DIR"

# DEPENDENCY CHECK
for dep in tar openssl base64 python3 curl sha256sum; do
    command -v "$dep" >/dev/null 2>&1 || {
        echo -e "${RED}Missing dependency: $dep${RESET}" >&2
        exit 1
    }
done

timestamp() { date '+%Y-%m-%d %H:%M:%S'; }

# LOGGING (KEEP 5 LOGS)
rotate_logs() {
    local max_logs=5
    for ((i=max_logs-1; i>=1; i--)); do
        [ -f "${LOG_FILE}.${i}" ] && mv "${LOG_FILE}.${i}" "${LOG_FILE}.$((i+1))"
    done
    [ -f "$LOG_FILE" ] && mv "$LOG_FILE" "${LOG_FILE}.1"
    : > "$LOG_FILE"
}
rotate_logs

log()      { echo -e "${CYAN}[INFO] $(timestamp)${RESET} $*" | tee -a "$LOG_FILE"; }
success()  { echo -e "${GREEN}[SUCCESS] $(timestamp)${RESET} $*" | tee -a "$LOG_FILE"; }
warn()     { echo -e "${YELLOW}[WARN] $(timestamp)${RESET} $*" | tee -a "$LOG_FILE"; }
error()    { echo -e "${RED}[ERROR] $(timestamp)${RESET} $*" | tee -a "$LOG_FILE" >&2; }
die()      { error "$*"; exit 1; }

# CONFIG AUTO-GENERATION
if [ ! -f "$CONFIG_FILE" ]; then
    cat > "$CONFIG_FILE" <<EOF
[server]
default_port = 8080
default_username = admin
default_password = changeme

[meta]
version = 1.0.0
build_date = $(date '+%Y-%m-%d')
EOF
fi

get_config_value() {
    local section="$1" key="$2" in_section=0
    while IFS='=' read -r k v; do
        [[ $k =~ ^\[.*\]$ ]] && in_section=0
        [[ $k == "[$section]" ]] && in_section=1 && continue
        [[ $in_section -eq 1 && $k =~ ^$key[[:space:]]*$ ]] && echo "${v// /}" && return
    done < "$CONFIG_FILE"
}

DEFAULT_PORT=$(get_config_value server default_port || echo "8080")
SCRIPT_VERSION=$(get_config_value meta version || echo "1.0.0")
BUILD_DATE=$(get_config_value meta build_date || echo "$(date '+%Y-%m-%d')")

resolve_path() {
    local path="$1"
    path="${path/#\~/$HOME}"
    [[ "$path" = /* ]] && echo "$path" || echo "$(pwd)/$path"
}

# 
# CORE FEATURES
# 

compress_file() {
    local target=$(resolve_path "$1")
    local output=$(resolve_path "${2:-${target%/}.tar.gz}")
    log "Compressing $target -> $output"

    case "$output" in
        *.tar.gz)
            if command -v tar >/dev/null 2>&1; then
                tar -czf "$output" -C "$(dirname "$target")" "$(basename "$target")"
                success "Compression complete: $output (tar.gz)"
            else
                die "tar not found. Install it to use .tar.gz compression."
            fi
            ;;
        *.zip)
            if command -v zip >/dev/null 2>&1; then
                zip -r "$output" "$target" >/dev/null
                success "Compression complete: $output (zip)"
            else
                die "zip not found. Install it to use .zip compression."
            fi
            ;;
        *.7z)
            if command -v 7z >/dev/null 2>&1; then
                7z a -t7z "$output" "$target" >/dev/null
                success "Compression complete: $output (7z)"
            else
                die "7z not found. Install p7zip to use .7z compression."
            fi
            ;;
        *)
            die "Unsupported compression format: ${output##*.}. Supported: .tar.gz, .zip, .7z"
            ;;
    esac
}

decompress_file() {
    local file=$(resolve_path "$1")
    local output_dir=$(resolve_path "${2:-${file%.*}_extracted}")
    mkdir -p "$output_dir"
    log "Decompressing $file -> $output_dir"

    case "$file" in
        *.tar.gz)
            if command -v tar >/dev/null 2>&1; then
                tar -xzf "$file" -C "$output_dir"
                success "Decompression complete: $output_dir (tar.gz)"
            else
                die "tar not found. Install it to extract .tar.gz files."
            fi
            ;;
        *.zip)
            if command -v unzip >/dev/null 2>&1; then
                unzip -o "$file" -d "$output_dir" >/dev/null
                success "Decompression complete: $output_dir (zip)"
            else
                die "unzip not found. Install it to extract .zip files."
            fi
            ;;
        *.7z)
            if command -v 7z >/dev/null 2>&1; then
                7z x "$file" -o"$output_dir" -y >/dev/null
                success "Decompression complete: $output_dir (7z)"
            else
                die "7z not found. Install p7zip to extract .7z files."
            fi
            ;;
        *)
            die "Unsupported archive format: ${file##*.}. Supported: .tar.gz, .zip, .7z"
            ;;
    esac
}

encode_file() {
    local file=$(resolve_path "$1")
    local output=$(resolve_path "${2:-${file%.*}.b64}")
    base64 < "$file" > "$output"
    success "Encoded $file -> $output"
}

decode_file() {
    local file=$(resolve_path "$1")
    local output=$(resolve_path "${2:-${file%.*}}")
    base64 --decode < "$file" > "$output"
    success "Decoded $file -> $output"
}

encrypt_file() {
    local file=$(resolve_path "$1")
    local output=$(resolve_path "${2:-${file}.enc}")
    local password="${PASSWORD_FLAG:-}"
    if [ -z "$password" ]; then
        read -rsp "Enter password: " password
        echo
    fi
    openssl enc -aes-256-cbc -salt -in "$file" -out "$output" -pass pass:"$password"
    success "Encrypted $file -> $output"
}

decrypt_file() {
    local file=$(resolve_path "$1")
    local output=$(resolve_path "${2:-${file%.enc}}")
    local password="${PASSWORD_FLAG:-}"
    if [ -z "$password" ]; then
        read -rsp "Enter password: " password
        echo
    fi
    openssl enc -d -aes-256-cbc -in "$file" -out "$output" -pass pass:"$password"
    success "Decrypted $file -> $output"
}

checksum_file() {
    local file=$(resolve_path "$1")
    local hash_file="${2:-${file}.sha256}"
    log "Generating checksum for $file"
    sha256sum "$file" | tee "$hash_file" | tee -a "$LOG_FILE"
    success "Checksum saved to $hash_file"
}

verify_checksum() {
    local file=$(resolve_path "$1")
    local hash_file=$(resolve_path "$2")
    log "Verifying checksum for $file using $hash_file"
    if sha256sum -c "$hash_file" &>/dev/null; then
        success "Checksum verified: $file is valid"
    else
        error "Checksum verification failed: $file is corrupted or altered"
        exit 1
    fi
}

serve_file() {
    local file=$(resolve_path "$1")
    log "Starting HTTP server for $file on port $DEFAULT_PORT"

    local server_script="$SERVER_SCRIPT"
    if [ ! -f "$server_script" ]; then
        warn "Server script not found locally. Downloading temporary copy..."
        server_script=$(mktemp)
        curl -s -o "$server_script" https://raw.githubusercontent.com/Gabriel-Dakinah-Vincent/Bash-exercises/refs/heads/b6se_/Modules/Linmod/Bash/b6se/src/server/run_server.py
    fi

    python3 "$server_script" --file "$file" >> "$LOG_FILE" 2>&1 &
    SERVER_PID=$!
    warn "Server started (PID $SERVER_PID). Press Ctrl+C to stop."
    trap 'warn "Stopping server..."; kill -TERM $SERVER_PID 2>/dev/null; wait $SERVER_PID 2>/dev/null; success "Server stopped"; exit 0' INT TERM
    wait $SERVER_PID
}

# HELP & VERSION
show_help() {
    echo -e "${BOLD}${BLUE}b6se — Secure Bash CLI Utility${RESET}"
    echo
    echo "Usage: ./b6se.sh [options]"
    echo
    echo "Options:"
    echo "  -c, --compress <target> [output]      Compress file/dir (.tar.gz, .zip, .7z)"
    echo "  -x, --decompress <file> [output]      Decompress archive (.tar.gz, .zip, .7z)"
    echo "  -e, --encode <file> [output]          Encode file to Base64"
    echo "  -d, --decode <file> [output]          Decode Base64 to file"
    echo "  -E, --encrypt <file> [output]         Encrypt file (use --password)"
    echo "  -D, --decrypt <file> [output]         Decrypt file (use --password)"
    echo "  -C, --checksum <file> [hashfile]      Generate SHA-256 checksum"
    echo "  -V, --verify <file> <hashfile>        Verify file against checksum"
    echo "  -s, --serve <file>                    Serve file via HTTP"
    echo "  -p, --password <pass>                 Set password for encrypt/decrypt"
    echo "  -v, --version                         Show version info"
    echo "  -h, --help                            Show this help message"
    echo
    echo "Example:"
    echo "  ./b6se.sh -c folder data.7z           # compress folder as .7z"
    echo "  ./b6se.sh -x archive.zip              # extract .zip file"
    echo "  ./b6se.sh -C archive.tar.gz           # create checksum"
    echo "  ./b6se.sh -V archive.tar.gz archive.tar.gz.sha256   # verify checksum"
}

show_version() {
    echo -e "${BOLD}${BLUE}b6se CLI Utility${RESET}"
    echo "Version: ${SCRIPT_VERSION}"
    echo "Build Date: ${BUILD_DATE}"
    echo "Root Path: ${PROJECT_ROOT}"
    echo
}

# PASSWORD HANDLER
PASSWORD_FLAG=""
ARGS=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p|--password) shift; PASSWORD_FLAG="$1"; shift;;
        *) ARGS+=("$1"); shift;;
    esac
done
set -- "${ARGS[@]}"

# MAIN ENTRY POINT 
case "${1:-}" in
    -c|--compress) shift; compress_file "$@";;
    -x|--decompress) shift; decompress_file "$@";;
    -e|--encode) shift; encode_file "$@";;
    -d|--decode) shift; decode_file "$@";;
    -E|--encrypt) shift; encrypt_file "$@";;
    -D|--decrypt) shift; decrypt_file "$@";;
    -C|--checksum) shift; checksum_file "$@";;
    -V|--verify) shift; verify_checksum "$@";;
    -s|--serve) shift; serve_file "$@";;
    -v|--version) show_version;;
    -h|--help|help) show_help;;
    *) echo -e "${YELLOW} Run './b6se.sh --help' for usage.${RESET}";;
esac