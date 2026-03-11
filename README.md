# 🎮 Phone motion control using sensors

A real-time gyroscope controller built with a **Flutter** mobile app, **Python WebSocket** backend, and an **HTML/CSS/JS** frontend. Tilt your phone to move elements on screen!



---

## 🚀 Getting Started

### 1. Python WebSocket Server

The server receives gyroscope data from the Flutter app and broadcasts it to all connected browser clients.

```bash
# Navigate to the server folder
cd server

# Install dependencies
pip install -r requirements.txt

# Run the server
python server.py
```

The server will start on:
- **WebSocket:** `ws://0.0.0.0:8765`

> Make sure your phone and computer are on the **same Wi-Fi network**.

---

### 2. Frontend (HTML/CSS/JS)

Open `frontend/index.html` in your browser, or serve it with a local server:

```bash
# Option A — open directly
open frontend/index.html

# Option B — serve with Python
cd frontend
python -m http.server 3000
# Then visit http://localhost:3000
```

The frontend connects to the WebSocket server and moves elements based on incoming gyro data.

---

### 3. Flutter App

The Flutter app reads the device gyroscope and sends `{ x, y, z }` orientation data to the Python server over WebSocket.

```bash
# Navigate to the Flutter app folder
cd flutter_app

# Install dependencies
flutter pub get

# Run on a connected device or emulator
flutter run
```

> ⚠️ Update the WebSocket server IP in `lib/main.dart` to match your computer's local IP address (e.g., `ws://192.168.1.100:8765`).

---

## 🛠️ Tech Stack

| Layer        | Technology                  |
|--------------|-----------------------------|
| Mobile App   | Flutter + `sensors_plus`    |
| Backend      | Python + `websockets`       |
| Frontend     | HTML / CSS / JavaScript     |
| Protocol     | WebSocket (ws://)           |

---

## 📦 Server Dependencies

**`server/requirements.txt`**

---

## 📱 Flutter Dependencies

**`flutter_app/pubspec.yaml`**

```yaml
dependencies:
  flutter:
    sdk: flutter
  sensors_plus: ^4.0.0
  web_socket_channel: ^2.4.0
```

---

## ⚙️ How It Works

```
📱 Flutter App
   └─ Reads gyroscope (x, y, z) via sensors_plus
   └─ Sends JSON over WebSocket → Python Server

🐍 Python Server
   └─ Receives gyro data from Flutter
   └─ Broadcasts to all connected browser clients

🌐 Browser (HTML/CSS/JS)
   └─ Connects to Python WebSocket server
   └─ Moves DOM elements using CSS transform / translate
      based on incoming x/y gyroscope values
```

---

## 🌐 Example WebSocket Message

```json
{
  "x": 0.45,
  "y": -0.12,
  "z": 0.03
}
```

The frontend maps `x` → horizontal movement and `y` → vertical movement.

---

## 🔧 Configuration

| Setting         | File                  | Default         |
|-----------------|-----------------------|-----------------|
| Server host     | `server/server.py`    | `0.0.0.0`       |
| Server port     | `server/server.py`    | `8765`          |
| Server IP (app) | `flutter_app/lib/main.dart` | `localhost` |

---

## 🐛 Troubleshooting

**Flutter can't connect to server**
- Ensure your phone and PC are on the same Wi-Fi
- Replace `localhost` with your computer's local IP in `main.dart`
- Check your firewall allows port `8765`

**Gyroscope not working on emulator**
- Use a real physical device; emulators don't have real gyroscope sensors

**Browser not receiving data**
- Make sure the frontend WebSocket URL matches the server IP and port
- Open browser DevTools → Console for error messages

---

## 📄 License

MIT — free to use and modify.
