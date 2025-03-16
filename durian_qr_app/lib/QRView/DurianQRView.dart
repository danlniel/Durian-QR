import 'package:durian_qr_app/PlantationForm/PlantationForm.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class DurianQRView extends StatefulWidget {
  const DurianQRView({super.key});

  @override
  State<DurianQRView> createState() => _DurianQRViewState();
}

class _DurianQRViewState extends State<DurianQRView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scannedCode;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Check if the scanned code is not null and we haven't processed any result yet
      if (scanData.code != null && scannedCode == null) {
        scannedCode = scanData.code!;
        controller.pauseCamera(); // Stop scanning after a successful read
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PlantationForm(qrCode: scannedCode!),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Code Scanner')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.blue,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 250,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                scannedCode == null ? 'Scanning...' : 'Scanned: $scannedCode',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
