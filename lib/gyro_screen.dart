import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GyroScreen extends StatefulWidget {
  final String url;
  const GyroScreen({super.key, required this.url});

  @override
  State<GyroScreen> createState() => _GyroScreenState();
}

class _GyroScreenState extends State<GyroScreen> {
  late WebSocketChannel channel;

  double rotX = 0, rotY = 0, rotZ = 0;
  static const double threshold = 0.05;

  double filter(double v) => v.abs() < threshold ? 0 : v;

  @override
  void initState() {
    super.initState();

    channel = WebSocketChannel.connect(Uri.parse(widget.url));

    channel.stream.listen(
      (msg) => debugPrint("WS recv: $msg"),
      onError: (e) => debugPrint("WS error: $e"),
      onDone: () => debugPrint("WS closed"),
    );

    channel.sink.add("external connection");

    gyroscopeEventStream(
      samplingPeriod: const Duration(microseconds: 16667), // ~60 Hz
    ).listen((e) {
      final fx = filter(e.x);
      final fy = filter(e.y);
      final fz = filter(e.z);

      rotX += fx;
      rotY += fy;
      rotZ += fz;

      final payload = {
        "live": {"x": e.x, "y": e.y, "z": e.z},
        "accumulated": {"x": rotX, "y": rotY, "z": rotZ},
      };

      channel.sink.add(jsonEncode(payload));
      debugPrint("sending gyro data");

      setState(() {});
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  Widget box(String title, String content) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(content),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gyroscope 🌀"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              widget.url,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          box("WebSocket URL", widget.url),
          box(
            "Accumulated Rotation",
            "X: ${rotX.toStringAsFixed(2)}\n"
                "Y: ${rotY.toStringAsFixed(2)}\n"
                "Z: ${rotZ.toStringAsFixed(2)}",
          ),
        ],
      ),
    );
  }
}
