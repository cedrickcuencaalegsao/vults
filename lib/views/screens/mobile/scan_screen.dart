import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/views/widgets/mobile/app_bar.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  ScanScreenState createState() => ScanScreenState();
}

class ScanScreenState extends State<ScanScreen> {
  MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    detectionTimeoutMs: 1000,
  );
  bool isScanComplete = false;
  String? scannedData;
  Barcode? lastScannedBarcode;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void closeScreen() {
    Navigator.pop(context);
  }

  void _resetScanner() {
    setState(() {
      isScanComplete = false;
      scannedData = null;
      lastScannedBarcode = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Scan QR Code',
        iconColor: ConstantString.darkBlue,
        fontColor: ConstantString.darkBlue,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: ConstantString.fontFredokaOne,
      ),
      body: Stack(
        children: [
          // Camera preview with scanner
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && !isScanComplete) {
                setState(() {
                  lastScannedBarcode = barcodes.first;
                  scannedData = lastScannedBarcode?.rawValue;
                  isScanComplete = true;
                });

                // Show result dialog
                _showScanResultDialog();
              }
            },
          ),

          // Scanner overlay with detection feedback
          _buildScannerOverlay(context),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildControlButtons(),
          ),

          // Scan instructions
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                'Align QR code within frame to scan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showScanResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Scan Result'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scannedData ?? 'No data found',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                if (lastScannedBarcode?.format != null)
                  Text(
                    'Format: ${lastScannedBarcode!.format.name}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetScanner();
                },
                child: const Text('Scan Again'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  closeScreen();
                },
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  Widget _buildScannerOverlay(BuildContext context) {
    return CustomPaint(
      painter: ScannerOverlay(
        scanArea: Rect.fromCenter(
          center: MediaQuery.of(context).size.center(Offset.zero),
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.width * 0.7,
        ),
        scannedBarcode: lastScannedBarcode,
      ),
    );
  }

  Widget _buildControlButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.1),
            Colors.black.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, _) {
                return Icon(
                  state == TorchState.on ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                  size: 28,
                );
              },
            ),
            label: 'Flash',
            onTap: () => cameraController.toggleTorch(),
          ),
          _buildControlButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, _) {
                return Icon(
                  state == CameraFacing.front
                      ? Icons.camera_front
                      : Icons.camera_rear,
                  color: Colors.white,
                  size: 28,
                );
              },
            ),
            label: 'Flip',
            onTap: () => cameraController.switchCamera(),
          ),
          _buildControlButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 28),
            label: 'Close',
            onTap: closeScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required Widget icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(icon: icon, onPressed: onTap, splashRadius: 24),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

class ScannerOverlay extends CustomPainter {
  final Rect scanArea;
  final Barcode? scannedBarcode;

  ScannerOverlay({required this.scanArea, this.scannedBarcode});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw semi-transparent overlay around scan area
    final backgroundPaint = Paint()..color = Colors.black.withValues(alpha: 0.3);

    // Draw top rectangle
    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width, scanArea.top),
      backgroundPaint,
    );

    // Draw bottom rectangle
    canvas.drawRect(
      Rect.fromLTRB(0, scanArea.bottom, size.width, size.height),
      backgroundPaint,
    );

    // Draw left rectangle
    canvas.drawRect(
      Rect.fromLTRB(0, scanArea.top, scanArea.left, scanArea.bottom),
      backgroundPaint,
    );

    // Draw right rectangle
    canvas.drawRect(
      Rect.fromLTRB(scanArea.right, scanArea.top, size.width, scanArea.bottom),
      backgroundPaint,
    );

    // Draw scan area border
    final borderPaint =
        Paint()
          ..color = scannedBarcode != null ? Colors.green : Colors.white
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;
    canvas.drawRect(scanArea, borderPaint);

    // Draw animated corners
    final cornerPaint =
        Paint()
          ..color = scannedBarcode != null ? Colors.green : Colors.blueAccent
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final cornerLength = 24.0;
    // final cornerRadius = 8.0;

    // Top-left corner
    canvas.drawLine(
      scanArea.topLeft,
      scanArea.topLeft + Offset(cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      scanArea.topLeft,
      scanArea.topLeft + Offset(0, cornerLength),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      scanArea.topRight,
      scanArea.topRight + Offset(-cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      scanArea.topRight,
      scanArea.topRight + Offset(0, cornerLength),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      scanArea.bottomRight,
      scanArea.bottomRight + Offset(-cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      scanArea.bottomRight,
      scanArea.bottomRight + Offset(0, -cornerLength),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      scanArea.bottomLeft,
      scanArea.bottomLeft + Offset(cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      scanArea.bottomLeft,
      scanArea.bottomLeft + Offset(0, -cornerLength),
      cornerPaint,
    );

    // If we have a scanned barcode, draw its corners
    if (scannedBarcode?.corners != null) {
      final barcodePaint =
          Paint()
            ..color = Colors.green.withValues(alpha:  0.8)
            ..strokeWidth = 3.0
            ..style = PaintingStyle.stroke;

      final corners = scannedBarcode!.corners;
      for (int i = 0; i < corners.length; i++) {
        final nextIndex = (i + 1) % corners.length;
        canvas.drawLine(
          Offset(corners[i].dx.toDouble(), corners[i].dy.toDouble()),
          Offset(
            corners[nextIndex].dx.toDouble(),
            corners[nextIndex].dy.toDouble(),
          ),
          barcodePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
