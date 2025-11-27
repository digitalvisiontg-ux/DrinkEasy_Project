import 'package:drink_eazy/App/Modules/Home/View/QrScanner.dart';
import 'package:flutter/material.dart';

class QrScannerModal extends StatefulWidget {
  const QrScannerModal({super.key});

  @override
  State<QrScannerModal> createState() => _QrScannerModalState();
}

class _QrScannerModalState extends State<QrScannerModal>
    with SingleTickerProviderStateMixin {
  late AnimationController scanController;
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    scanController.dispose();
    super.dispose();
  }

  Future<void> startFakeScan() async {
    if (isScanning) return;

    setState(() => isScanning = true);
    scanController.repeat(reverse: true);

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    scanController.stop();
    setState(() => isScanning = false);

    Navigator.pop(context); // Ferme le modal

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QrScannerPage()),
    );

    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('QR détecté : $result'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ---- Header ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Scanner le QR Code',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Icon(Icons.close, color: Colors.black54),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ---- QR Box + animation ----
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.amber, width: 3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.qr_code_2,
                        color: Colors.grey,
                        size: 70,
                      ),
                    ),
                  ),

                  // --- ANIMATION DE SCAN ---
                  if (isScanning)
                    AnimatedBuilder(
                      animation: scanController,
                      builder: (_, child) {
                        return Positioned(
                          top: 20 + (scanController.value * 120),
                          child: Container(
                            width: 120,
                            height: 3,
                            color: Colors.amber,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---- Description ----
            const Text(
              "Pointez votre caméra vers le QR code de votre table pour continuer",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, height: 1.4),
            ),

            const SizedBox(height: 24),

            // ---- Bouton principal ----
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isScanning ? null : startFakeScan,
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.black,
                ),
                label: Text(
                  isScanning ? 'Scan en cours...' : 'Scanner maintenant',
                  style: const TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isScanning
                      ? Colors.grey.shade400
                      : Colors.amber,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
