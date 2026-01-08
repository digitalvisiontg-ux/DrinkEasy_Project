import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage>
    with SingleTickerProviderStateMixin {
  bool _hasDetected = false;

  late final AnimationController _animationController;
  late final Animation<double> _laserAnimation;

  static const double _scanAreaSize = 260;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDetection(BarcodeCapture capture) {
    if (_hasDetected) return;

    final barcode = capture.barcodes.first;
    final value = barcode.rawValue;

    if (value == null || value.isEmpty) return;

    _hasDetected = true;
    Navigator.pop(context, value); // retourne le token QR
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          /// Camera
          MobileScanner(
            fit: BoxFit.cover,
            onDetect: _handleDetection,
          ),

          /// Overlay sombre avec découpe centrale
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.65),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Center(
                  child: Container(
                    width: _scanAreaSize,
                    height: _scanAreaSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Cadre + laser animé
          CustomPaint(
            painter: _ScannerBorderPainter(),
            child: SizedBox(
              width: _scanAreaSize,
              height: _scanAreaSize,
              child: AnimatedBuilder(
                animation: _laserAnimation,
                builder: (_, __) {
                  return CustomPaint(
                    painter:
                        _ScannerLaserPainter(progress: _laserAnimation.value),
                  );
                },
              ),
            ),
          ),

          /// Header
          Positioned(
            top: size.height * 0.06,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const Text(
                  'Scanner un QR Code',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          /// Texte guide
          const Positioned(
            bottom: 90,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'Placez le QR code dans le cadre',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'La détection est automatique',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Cadre du scanner
class _ScannerBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.amber, Colors.orangeAccent],
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(20),
    );

    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

/// Laser animé
class _ScannerLaserPainter extends CustomPainter {
  final double progress;

  _ScannerLaserPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height * progress;

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Colors.transparent,
          Colors.amber,
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromLTWH(0, y - 1, size.width, 2),
      )
      ..strokeWidth = 3;

    canvas.drawLine(
      Offset(0, y),
      Offset(size.width, y),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScannerLaserPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
