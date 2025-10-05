import http.server
import socketserver
import argparse
import sys
import os
from functools import partial

class SecureHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, password=None, **kwargs):
        self.password = password
        super().__init__(*args, **kwargs)

    def do_GET(self):
        if self.password:
            auth = self.headers.get('Authorization')
            if not auth or auth.split()[-1] != self.password:
                self.send_response(401)
                self.send_header('WWW-Authenticate', 'Basic realm="b6se Secure Server"')
                self.end_headers()
                self.wfile.write(b"Unauthorized")
                return
        return super().do_GET()

def main():
    parser = argparse.ArgumentParser(description="b6se Secure File Server")
    parser.add_argument('--file', required=True, help='Path to file or directory to serve')
    parser.add_argument('--port', type=int, default=8080, help='Port number (default: 8080)')
    parser.add_argument('--password', help='Password for simple authentication')
    args = parser.parse_args()

    os.chdir(os.path.dirname(os.path.abspath(args.file)))

    handler = partial(SecureHTTPRequestHandler, password=args.password)
    with socketserver.TCPServer(("", args.port), handler) as httpd:
        print(f"Serving '{args.file}' at http://localhost:{args.port}")
        print("Press Ctrl+C to stop.")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer stopped gracefully.")
            sys.exit(0)

if __name__ == "__main__":
    main()