// // QRScanPage.dart
// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

// class QRScanPage extends StatefulWidget {
//   const QRScanPage({Key? key}) : super(key: key);

//   @override
//   State<QRScanPage> createState() => _QRScanPageState();
// }

// class _QRScanPageState extends State<QRScanPage> {
//   bool _detected = false;
//   MobileScannerController? _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = MobileScannerController(
//       // options utiles si tu veux (torch, facing, formats...) :
//       // torchEnabled: false,
//       // facing: CameraFacing.back,
//     );
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.close, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           "Scanner le QR Code",
//           style: TextStyle(color: Colors.white),
//         ),
//         actions: [
//           // Toggle lampe si nécessaire
//           IconButton(
//             icon: const Icon(Icons.flash_on, color: Colors.white70),
//             onPressed: () async {
//               try {
//                 await _controller?.toggleTorch();
//               } catch (_) {}
//             },
//           ),
//         ],
//       ),
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           MobileScanner(
//             controller: _controller,
//             onDetect: (capture) {
//               // capture peut contenir plusieurs barcodes ; on gère la première détection valide
//               if (_detected) return;
//               final List<Barcode> barcodes = capture.barcodes;
//               if (barcodes.isEmpty) return;

//               final raw = barcodes.first.rawValue ?? '';
//               final tableNumber = _extractTableNumber(raw);

//               if (tableNumber != null) {
//                 _detected = true;
//                 // petite vibration / feedback (optionnel)
//                 // HapticFeedback.selectionClick();
//                 Navigator.of(context).pop(tableNumber);
//               } else {
//                 // feedback si QR invalide
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text("QR invalide"),
//                     backgroundColor: Colors.redAccent,
//                   ),
//                 );
//               }
//             },
//           ),

//           // Cadre visuel pour guider l'utilisateur
//           Container(
//             width: 260,
//             height: 260,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.white70, width: 2),
//               borderRadius: BorderRadius.circular(20),
//             ),
//           ),

//           Positioned(
//             bottom: 60,
//             child: Column(
//               children: const [
//                 Text(
//                   "Placez le QR code dans le cadre",
//                   style: TextStyle(color: Colors.white70, fontSize: 16),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// Essaye d'extraire un numéro à partir du texte lu (ex: "3" ou "table:3")
//   int? _extractTableNumber(String raw) {
//     final cleaned = raw.toLowerCase().replaceAll(RegExp(r'[^0-9:]'), '');
//     if (cleaned.isEmpty) return null;

//     if (cleaned.contains(':')) {
//       final parts = cleaned.split(':');
//       if (parts.length >= 2) {
//         return int.tryParse(parts[1]);
//       }
//     }

//     return int.tryParse(cleaned);
//   }
// }
