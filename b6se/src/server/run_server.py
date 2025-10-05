import http.server
import socketserver
import sys
import os
import configparser
import base64
from functools import partial

class SecureHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, username=None, password=None, **kwargs):
        self.username = username
        self.password = password
        super().__init__(*args, **kwargs)

    def do_GET(self):
        if self.password and self.username:
            auth = self.headers.get('Authorization')
            if not auth or not auth.startswith("Basic "):
                self._unauthorized()
                return

            try:
                decoded = base64.b64decode(auth.split()[1]).decode()
                user, pwd = decoded.split(":", 1)
            except Exception:
                self._unauthorized()
                return

            if user != self.username or pwd != self.password:
                self._unauthorized()
                return

        return super().do_GET()

    def _unauthorized(self):
        self.send_response(401)
        self.send_header('WWW-Authenticate', 'Basic realm=\"b6se Secure Server\"')
        self.end_headers()
        self.wfile.write(b"Unauthorized")

def main():
    config = configparser.ConfigParser()
    config.read(os.path.join(os.path.dirname(__file__), '../../config/config.ini'))
    default_port = int(config.get('server', 'default_port', fallback='8080'))
    default_username = config.get('server', 'default_username', fallback='user')
    default_password = config.get('server', 'default_password', fallback='changeme')

    if len(sys.argv) < 3 or sys.argv[1] != '--file':
        print("Usage: run_server.py --file <path>")
        sys.exit(1)

    file_path = sys.argv[2]
    os.chdir(os.path.dirname(os.path.abspath(file_path)))

    handler = partial(SecureHTTPRequestHandler, username=default_username, password=default_password)
    with socketserver.TCPServer(("", default_port), handler) as httpd:
        print(f"Serving '{file_path}' at http://localhost:{default_port}")
        print(f"🔐 Authentication required → Username: {default_username}, Password: {default_password}")
        print("Press Ctrl+C to stop.")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer stopped gracefully.")
            sys.exit(0)

if __name__ == "__main__":
    main()
