#!/usr/bin/env python3
"""
run_server.py — Secure Temporary HTTPS File Server
Supports password protection, one-time download, TLS auto-generation, and limited downloads.
"""

import argparse, os, base64, ssl
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
from functools import partial

class SecureHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, file_path=None, password=None, one_time=False, max_downloads=0, **kwargs):
        self.file_path = file_path
        self.password = password
        self.one_time = one_time
        self.max_downloads = max_downloads
        self.downloads = 0
        super().__init__(*args, **kwargs)

    def do_GET(self):
        if self.password:
            auth = self.headers.get("Authorization")
            if not auth or not auth.startswith("Basic "):
                self._unauthorized()
                return
            _, encoded = auth.split(" ", 1)
            user_pass = base64.b64decode(encoded).decode()
            if ":" not in user_pass or user_pass.split(":", 1)[1] != self.password:
                self._unauthorized()
                return

        if not os.path.exists(self.file_path):
            self.send_error(404, "File not found")
            return

        with open(self.file_path, "rb") as f:
            content = f.read()

        self.send_response(200)
        self.send_header("Content-Type", "application/octet-stream")
        self.send_header("Content-Disposition", f'attachment; filename="{os.path.basename(self.file_path)}"')
        self.send_header("Content-Length", str(len(content)))
        self.end_headers()
        self.wfile.write(content)

        self.downloads += 1
        if self.one_time or (self.max_downloads and self.downloads >= self.max_downloads):
            os.remove(self.file_path)
            os._exit(0)

    def _unauthorized(self):
        self.send_response(401)
        self.send_header("WWW-Authenticate", 'Basic realm="Protected"')
        self.end_headers()
        self.wfile.write(b"Unauthorized")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--file", required=True)
    parser.add_argument("--port", type=int, default=8080)
    parser.add_argument("--password")
    parser.add_argument("--one-time", action="store_true")
    parser.add_argument("--max", type=int, default=0)
    parser.add_argument("--tls", action="store_true")
    args = parser.parse_args()

    handler = partial(SecureHandler, file_path=args.file, password=args.password, one_time=args.one_time, max_downloads=args.max)
    httpd = ThreadingHTTPServer(("0.0.0.0", args.port), handler)

    if args.tls:
        cert, key = "server.crt", "server.key"
        if not os.path.exists(cert) or not os.path.exists(key):
            os.system(f"openssl req -x509 -newkey rsa:2048 -keyout {key} -out {cert} -days 1 -nodes -subj '/CN=localhost'")
        ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
        ctx.load_cert_chain(cert, key)
        httpd.socket = ctx.wrap_socket(httpd.socket, server_side=True)

    print(f"Serving {args.file} on port {args.port} (TLS={args.tls})")
    httpd.serve_forever()

if __name__ == "__main__":
    main()