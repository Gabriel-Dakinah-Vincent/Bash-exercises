#!/usr/bin/env python3
import http.server, ssl, argparse, os, time

class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.server.password:
            auth = self.headers.get('Authorization')
            if not auth or auth != "Basic " + self.server.password:
                self.send_response(401)
                self.send_header('WWW-Authenticate', 'Basic realm="b6se"')
                self.end_headers()
                return
        filepath = os.path.join(self.server.dir, self.server.file)
        if not os.path.exists(filepath):
            self.send_error(404, "File not found")
            return
        self.send_response(200)
        self.end_headers()
        with open(filepath, "rb") as f:
            self.wfile.write(f.read())
        self.server.downloads += 1
        if self.server.one_time or (self.server.max_downloads and self.server.downloads >= self.server.max_downloads):
            os.remove(filepath)

def run(args):
    os.chdir(os.path.dirname(args.file))
    handler = Handler
    server = http.server.HTTPServer(("0.0.0.0", args.port), handler)
    server.file = os.path.basename(args.file)
    server.dir = os.getcwd()
    server.password = args.password
    server.one_time = bool(args.one_time)
    server.max_downloads = args.max_downloads
    server.downloads = 0

    if args.tls:
        if not os.path.exists("cert.pem") or not os.path.exists("key.pem"):
            os.system("openssl req -x509 -newkey rsa:2048 -nodes -keyout key.pem -out cert.pem -subj '/CN=localhost'")
        server.socket = ssl.wrap_socket(server.socket, certfile="cert.pem", keyfile="key.pem", server_side=True)

    deadline = time.time() + args.timeout * 60
    while time.time() < deadline:
        server.handle_request()

if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--file", required=True)
    ap.add_argument("--port", type=int, default=8000)
    ap.add_argument("--password", default=None)
    ap.add_argument("--one-time", default=False)
    ap.add_argument("--max-downloads", type=int, default=None)
    ap.add_argument("--timeout", type=int, default=10)
    ap.add_argument("--tls", default=False)
    run(ap.parse_args())