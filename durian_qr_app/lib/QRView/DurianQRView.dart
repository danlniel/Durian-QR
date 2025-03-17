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
      if (scanData.code != null && scannedCode == null) {
        scannedCode = scanData.code!;

        // Add .then() to handle returning from PlantationForm
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantationForm(qrCode: scannedCode!),
          ),
        ).then((_) {
          // Reset scannedCode and resume camera when returning
          if (mounted) {
            setState(() {
              scannedCode = null;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
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
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}