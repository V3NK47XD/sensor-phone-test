import flask
import socket
import asyncio
import threading
import websockets
import qrcode
from io import BytesIO
import base64

app = flask.Flask(__name__)
app.config["DEBUG"] = True

WS_PORT = 8765
FLASK_PORT = 5000
clients = set()

# 🔍 Get local IP
def get_local_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
    finally:
        s.close()
    return ip

HOST_IP = get_local_ip()

# 🔌 WebSocket server
async def ws_handler(websocket):
    print("Client connected 🤝")
    clients.add(websocket)

    try:
        async for message in websocket:
            print("Received:", message)

            for client in clients:
                await client.send(message)
    finally:
        clients.remove(websocket)

async def start_ws():
    async with websockets.serve(ws_handler, "0.0.0.0", WS_PORT):
        print(f"WebSocket running on ws://{HOST_IP}:{WS_PORT}")
        await asyncio.Future()

def run_ws():
    asyncio.run(start_ws())

# 🌐 Flask route
@app.route("/")
def home():
    ws_url = f"ws://{HOST_IP}:{WS_PORT}"

    qr = qrcode.make(ws_url)
    buffer = BytesIO()
    qr.save(buffer, format="PNG")
    qr_base64 = base64.b64encode(buffer.getvalue()).decode()

    return flask.render_template(
        "game.html",
        ws_url=ws_url,
        qr_code=qr_base64
    )

if __name__ == "__main__":
    threading.Thread(target=run_ws, daemon=True).start()
    app.run(host="0.0.0.0", port=FLASK_PORT, use_reloader=False)
