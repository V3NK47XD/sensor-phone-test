import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'gyro_screen.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR 📷")),
      body: MobileScanner(
        onDetect: (capture) {
          final code = capture.barcodes.first.rawValue;
          if (code == null) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => GyroScreen(url: code)),
          );
        },
      ),
    );
  }
}
