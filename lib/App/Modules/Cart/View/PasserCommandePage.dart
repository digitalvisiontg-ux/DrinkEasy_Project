// // PasserCommandePage.dart
// // Page "Passer la commande" — design fidèle à ton layout panier
// // Le constructeur prend maintenant la liste cartItems réelle.

// import 'dart:async';
// import 'package:drink_eazy/App/Modules/Cart/View/CommandeValideePage.dart';
// import 'package:drink_eazy/App/Modules/Cart/View/QrScan_Page.dart'
//     show QRScanPage;
// import 'package:drink_eazy/App/Modules/Home/View/QrScanner.dart';
// import 'package:flutter/material.dart';
// import 'package:get/route_manager.dart';

// class PasserCommandePage extends StatefulWidget {
//   final List<Map<String, dynamic>> cartItems;

//   const PasserCommandePage({Key? key, required this.cartItems})
//     : super(key: key);

//   @override
//   State<PasserCommandePage> createState() => _PasserCommandePageState();
// }

// class _PasserCommandePageState extends State<PasserCommandePage>
//     with SingleTickerProviderStateMixin {
//   final TextEditingController tableController = TextEditingController(
//     text: "00",
//   );

//   int currentStep = 1;
//   bool isScanning = false;
//   String selectedTable = "00";
//   int tableNumber = 0;

//   late AnimationController scanController;
//   late Animation<double> scanAnim;

//   List<Map<String, dynamic>> get cartItems => widget.cartItems;

//   int get totalPrice {
//     int total = 0;
//     for (final item in cartItems) {
//       final product = item['product'];
//       final qty = item['quantity'] ?? 0;
//       final int price = ((product?.priceCfa ?? product?['priceCfa']) as num)
//           .toInt();
//       total += price * (qty as int);
//     }
//     return total;
//   }

//   @override
//   void initState() {
//     super.initState();
//     scanController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     );
//     scanAnim = CurvedAnimation(parent: scanController, curve: Curves.easeInOut);
//   }

//   @override
//   void dispose() {
//     scanController.dispose();
//     tableController.dispose();
//     super.dispose();
//   }

//   void startScan() {
//     if (isScanning) return;

//     setState(() {
//       isScanning = true;
//       scanController.repeat(reverse: true);
//     });

//     // Simulation d'animation de scan avant d’ouvrir la vraie page
//     Timer(const Duration(milliseconds: 1500), () async {
//       if (!mounted) return;

//       scanController.stop();
//       setState(() => isScanning = false);

//       final scannedTable = await Navigator.push(
//         context,
//         MaterialPageRoute(builder: (_) => const QrScannerPage()),
//       );

//       if (scannedTable != null) {
//         setState(() {
//           selectedTable = scannedTable.toString();
//           tableController.text = selectedTable;
//           currentStep = 2;
//         });
//       }
//     });
//   }

//   void confirmManual() {
//     if (tableController.text == "00" || tableController.text.isEmpty) return;
//     setState(() {
//       selectedTable = tableController.text.trim();
//       currentStep = 2;
//     });
//   }

//   // Formatting numbers
//   String formatCFA(int price) {
//     final s = price.toString();
//     final buffer = StringBuffer();
//     int count = 0;
//     for (int i = s.length - 1; i >= 0; i--) {
//       buffer.write(s[i]);
//       count++;
//       if (count == 3 && i != 0) {
//         buffer.write(" ");
//         count = 0;
//       }
//     }
//     return buffer.toString().split("").reversed.join();
//   }

//   // Compte total d'articles (quantités)
//   int _countArticles() {
//     int count = 0;
//     for (final item in cartItems) {
//       final q = item['quantity'] ?? 0;
//       count += (q as int);
//     }
//     return count;
//   }

//   // Récupère proprement les champs du product (compatible instance ou Map)
//   String _productName(dynamic product) {
//     try {
//       return product.name as String;
//     } catch (_) {
//       return (product['name'] ?? '') as String;
//     }
//   }

//   int _productPrice(dynamic product) {
//     try {
//       return (product.priceCfa as num).toInt();
//     } catch (_) {
//       return ((product['priceCfa'] ?? 0) as num).toInt();
//     }
//   }

//   String? _productImage(dynamic product) {
//     try {
//       final img = product.imagepath;
//       return img is String && img.isNotEmpty ? img : null;
//     } catch (_) {
//       final img = product['imagepath'];
//       return img is String && img.isNotEmpty ? img : null;
//     }
//   }

//   String _productCategory(dynamic product) {
//     try {
//       return product.category ?? '';
//     } catch (_) {
//       return product['category'] ?? '';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F7FB),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0.4,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black87),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           "Passer la commande",
//           style: TextStyle(
//             color: Colors.black87,
//             fontWeight: FontWeight.w700,
//             fontSize: 18,
//           ),
//         ),
//       ),
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: currentStep == 1 ? buildStep1(context) : buildStep2(context),
//           ),
//           if (currentStep == 2) buildBottomCTA(),
//         ],
//       ),
//     );
//   }

//   Widget buildStep1(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.fromLTRB(18, 18, 18, 140),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           buildStepHeader(step2: false),
//           const SizedBox(height: 22),

//           // QR card
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               children: [
//                 Container(
//                   width: MediaQuery.of(context).size.width * 0.3,
//                   height: MediaQuery.of(context).size.width * 0.3,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFFFF4C0),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       const Icon(
//                         Icons.qr_code_scanner_rounded,

//                         size: 70,
//                         color: Color(0xFFE0A900),
//                       ),
//                       if (isScanning)
//                         AnimatedBuilder(
//                           animation: scanAnim,
//                           builder: (_, child) {
//                             return Positioned(
//                               top: 20 + scanAnim.value * 90,
//                               left: 30,
//                               right: 30,
//                               child: Container(
//                                 height: 5,
//                                 decoration: BoxDecoration(
//                                   color: Colors.yellow.shade800,
//                                   borderRadius: BorderRadius.circular(4),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 18),

//                 GestureDetector(
//                   onTap: startScan,
//                   child: Material(
//                     elevation: 1,
//                     borderRadius: BorderRadius.circular(34),
//                     child: Container(
//                       height: 45,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFFFD73C),
//                         borderRadius: BorderRadius.circular(34),
//                       ),
//                       child: Center(
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             if (isScanning)
//                               const SizedBox(
//                                 height: 18,
//                                 width: 18,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.black,
//                                 ),
//                               )
//                             else
//                               const Icon(
//                                 Icons.camera_alt_outlined,
//                                 color: Colors.black,
//                                 size: 18,
//                               ),
//                             const SizedBox(width: 10),
//                             Text(
//                               isScanning
//                                   ? "Scan en cours..."
//                                   : "Scanner le QR code",
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w700,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 22),

//           Row(
//             children: [
//               Expanded(child: Divider(color: Colors.grey.shade300)),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 12),
//                 child: Text(
//                   "ou",
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               Expanded(child: Divider(color: Colors.grey.shade300)),
//             ],
//           ),

//           const SizedBox(height: 22),

//           // Manual input
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               children: [
//                 const Text(
//                   "Saisie manuelle",
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
//                 ),
//                 const SizedBox(height: 14),
//                 Container(
//                   height: 60,
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF7F8FA),
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: tableController,
//                           keyboardType: TextInputType.number,
//                           maxLength: 2,
//                           style: const TextStyle(
//                             fontSize: 32,
//                             color: Colors.grey,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           textAlign: TextAlign.center,
//                           decoration: const InputDecoration(
//                             counterText: "",
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                       const Text(
//                         "#",
//                         style: TextStyle(
//                           fontSize: 28,
//                           color: Colors.grey,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 GestureDetector(
//                   onTap: confirmManual,
//                   child: Container(
//                     height: 55,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(34),
//                       border: Border.all(color: Colors.grey.shade300),
//                     ),
//                     child: const Center(
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.check, color: Colors.black),
//                           SizedBox(width: 10),
//                           Text(
//                             "Confirmer",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ---------------------------------------------------
//   // STEP 2 (Confirmation)
//   // ---------------------------------------------------
//   Widget buildStep2(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           buildStepHeader(step2: true),
//           const SizedBox(height: 22),
//           // Yellow table card
//           Container(
//             padding: const EdgeInsets.all(18),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color.fromARGB(255, 255, 161, 54), Color(0xFFFFC107)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.20),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(
//                     Icons.restaurant_menu,
//                     color: Colors.white,
//                     size: 26,
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Votre table",
//                       style: TextStyle(color: Colors.black, fontSize: 14),
//                     ),
//                     const SizedBox(height: 3),
//                     Text(
//                       "Table #$selectedTable",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 19,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 22),

//           // White order summary
//           Container(
//             padding: const EdgeInsets.all(18),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header + badge
//                 Row(
//                   children: [
//                     const Expanded(
//                       child: Text(
//                         "Votre commande",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w800,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFE8FFF3),
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       child: Text(
//                         "${_countArticles()} articles",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w700,
//                           color: Color(0xFF2AA55B),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 18),

//                 Column(
//                   children: List.generate(cartItems.length, (i) {
//                     final item = cartItems[i];
//                     final product = item["product"];
//                     final int q = (item["quantity"] as num).toInt();
//                     final int price = _productPrice(product);
//                     final int subtotal = price * q;

//                     return Column(
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               width: 30,
//                               height: 30,
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFFFF4E0),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "${i + 1}",
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                     color: Color(0xFFB76D00),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     _productName(product),
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     "×$q",
//                                     style: TextStyle(
//                                       fontSize: 13,
//                                       color: Colors.grey.shade600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Text(
//                               "${formatCFA(subtotal)} CFA",
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ],
//                         ),
//                         if (i < cartItems.length - 1)
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                             child: Divider(color: Colors.grey.shade200),
//                           ),
//                       ],
//                     );
//                   }),
//                 ),

//                 const SizedBox(height: 12),
//                 Divider(color: Colors.grey.shade200),
//                 const SizedBox(height: 12),

//                 Row(
//                   children: [
//                     const Expanded(
//                       child: Text(
//                         "Total",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 15,
//                         ),
//                       ),
//                     ),
//                     Text(
//                       "${formatCFA(totalPrice)} CFA",
//                       style: const TextStyle(
//                         fontSize: 21,
//                         fontWeight: FontWeight.w900,
//                         color: Color(0xFFB00020),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 22),

//           // Info box
//           // Container(
//           //   padding: const EdgeInsets.all(16),
//           //   decoration: BoxDecoration(
//           //     color: const Color(0xFFFFF4EA),
//           //     borderRadius: BorderRadius.circular(16),
//           //     border: Border.all(color: Colors.orange.shade100),
//           //   ),
//           //   child: Row(
//           //     crossAxisAlignment: CrossAxisAlignment.start,
//           //     children: [
//           //       Icon(Icons.info_outline, color: Colors.orange.shade800),
//           //       const SizedBox(width: 12),
//           //       const Expanded(
//           //         child: Text(
//           //           "Votre commande sera préparée et livrée à votre table dans environ 10-20 minutes.",
//           //           style: TextStyle(fontSize: 13),
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }

//   // ---------------------------------------------------
//   // FOOTER CTA
//   // ---------------------------------------------------
//   Widget buildBottomCTA() {
//     return Positioned(
//       // J'aimerai que la possition soit relative au bas de l'écran et responsive pour tous les écrans
//       bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//       left: 18,
//       right: 18,
//       child: ElevatedButton.icon(
//         onPressed: () {
//           // rediriger vers la page de commandeValidée
//           Get.to(
//             CommandeValideePage(
//               cartItems: cartItems,
//               totalPrice: totalPrice,
//               tableNumber: tableNumber,
//             ),
//           );
//         },
//         icon: const Icon(
//           Icons.check_circle_outline,
//           size: 20,
//           color: Colors.black,
//         ),
//         label: const Text(
//           "Confirmer la commande",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.amber,
//           minimumSize: const Size.fromHeight(50),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(30),
//           ),
//         ),
//       ),
//     );
//   }

//   // ---------------------------------------------------
//   // Step header
//   // ---------------------------------------------------
//   Widget buildStepHeader({required bool step2}) {
//     return Row(
//       children: [
//         // ------------ STEP 1 -------------
//         Expanded(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 30,
//                 height: 30,
//                 decoration: BoxDecoration(
//                   color: step2 ? Colors.green : const Color(0xFFFFD73C),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Center(
//                   child: step2
//                       ? const Icon(Icons.check, color: Colors.white, size: 18)
//                       : const Text(
//                           "1",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w700,
//                             color: Colors.black,
//                           ),
//                         ),
//                 ),
//               ),
//               const SizedBox(width: 6),
//               Flexible(
//                 child: FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Text(
//                     "Numéro de table",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // ------------ LINE -------------
//         Container(
//           width: 30,
//           height: 3,
//           color: step2 ? Colors.green : Colors.grey.shade300,
//         ),

//         // ------------ STEP 2 -------------
//         Expanded(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 30,
//                 height: 30,
//                 decoration: BoxDecoration(
//                   color: step2 ? const Color(0xFFFFD73C) : Colors.grey.shade300,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Center(
//                   child: Text(
//                     "2",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w700,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 6),
//               Flexible(
//                 child: FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Text(
//                     "Confirmation",
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: step2 ? Colors.black : Colors.grey,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// PasserCommandePage.dart
import 'dart:async';
import 'package:drink_eazy/App/Modules/Cart/View/CommandeValideePage.dart';
import 'package:drink_eazy/App/Modules/Cart/View/QrScan_Page.dart'
    show QRScanPage;
import 'package:drink_eazy/App/Modules/Home/View/QrScanner.dart';
import 'package:flutter/material.dart';
import 'package:drink_eazy/App/Modules/Cart/View/CommandeValideePage.dart';
import 'package:drink_eazy/App/Modules/Home/View/QrScanner.dart'; // si tu utilises la page QR
// Remplace les imports selon ton arborescence réelle

class PasserCommandePage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const PasserCommandePage({Key? key, required this.cartItems})
    : super(key: key);

  @override
  State<PasserCommandePage> createState() => _PasserCommandePageState();
}

class _PasserCommandePageState extends State<PasserCommandePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController tableController = TextEditingController(
    text: "00",
  );
  int currentStep = 1;
  bool isScanning = false;
  String selectedTable = "00";
  late AnimationController scanController;
  late Animation<double> scanAnim;

  List<Map<String, dynamic>> get cartItems => widget.cartItems;

  int get totalPrice {
    int total = 0;
    for (final item in cartItems) {
      final product = item['product'];
      final qty = item['quantity'] ?? 0;
      final int price = ((product?.priceCfa ?? product?['priceCfa']) as num)
          .toInt(); // compatible instance/map
      total += price * (qty as int);
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    scanAnim = CurvedAnimation(parent: scanController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    scanController.dispose();
    tableController.dispose();
    super.dispose();
  }

  void startScan() {
    if (isScanning) return;

    setState(() {
      isScanning = true;
      scanController.repeat(reverse: true);
    });

    Timer(const Duration(milliseconds: 1500), () async {
      if (!mounted) return;
      scanController.stop();
      setState(() => isScanning = false);

      // Ouvre ta page scanner réelle et attends le résultat (table)
      // Ici j'utilise QrScannerPage (tu as montré plusieurs variantes)
      final scannedTable = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const QrScannerPage()),
      );

      if (scannedTable != null) {
        setState(() {
          selectedTable = scannedTable.toString();
          tableController.text = selectedTable;
          currentStep = 2;
        });
      }
    });
  }

  void confirmManual() {
    if (tableController.text == "00" || tableController.text.isEmpty) return;
    setState(() {
      selectedTable = tableController.text.trim();
      currentStep = 2;
    });
  }

  String formatCFA(int price) {
    final s = price.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write(" ");
        count = 0;
      }
    }
    return buffer.toString().split("").reversed.join();
  }

  int _countArticles() {
    int count = 0;
    for (final item in cartItems) {
      final q = item['quantity'] ?? 0;
      count += (q as int);
    }
    return count;
  }

  String _productName(dynamic product) {
    try {
      return product.name as String;
    } catch (_) {
      return (product['name'] ?? '') as String;
    }
  }

  int _productPrice(dynamic product) {
    try {
      return (product.priceCfa as num).toInt();
    } catch (_) {
      return ((product['priceCfa'] ?? 0) as num).toInt();
    }
  }

  Widget buildStepHeader({required bool step2}) {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: step2 ? Colors.green : const Color(0xFFFFD73C),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: step2
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : const Text(
                          "1",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Numéro de table",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 30,
          height: 3,
          color: step2 ? Colors.green : Colors.grey.shade300,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: step2 ? const Color(0xFFFFD73C) : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    "2",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Confirmation",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: step2 ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // BOUTON final : confirme, ouvre CommandeValideePage et renvoie le résultat au caller (Home)
  Future<void> _onConfirmAndShowValidated() async {
    if (selectedTable == "00" || selectedTable.isEmpty) {
      // show a snack/toast — tu as showToastComponent dans ton projet
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez sélectionner une table.")),
      );
      return;
    }

    // Générer orderId
    final String orderId = "CMD-${DateTime.now().millisecondsSinceEpoch}";

    // Ouvrir la page de commande validée et attendre le résultat
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CommandeValideePage(
          cartItems: cartItems,
          totalPrice: totalPrice,
          tableNumber: int.parse(selectedTable),
        ),
      ),
    );

    // Si CommandeValideePage renvoie un Map, on retourne ce Map à Home
    if (result is Map) {
      // result attendu: {"table": selectedTable, "orderId": orderId, "items": cartItems, "totalPrice": totalPrice}
      Navigator.pop(context, result);
    }
  }

  Widget buildStep1(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildStepHeader(step2: false),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4C0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 70,
                        color: Color(0xFFE0A900),
                      ),
                      if (isScanning)
                        AnimatedBuilder(
                          animation: scanAnim,
                          builder: (_, child) {
                            return Positioned(
                              top: 20 + scanAnim.value * 90,
                              left: 30,
                              right: 30,
                              child: Container(
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Colors.yellow.shade800,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: startScan,
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(34),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD73C),
                        borderRadius: BorderRadius.circular(34),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isScanning)
                              const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            else
                              const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.black,
                                size: 18,
                              ),
                            const SizedBox(width: 10),
                            Text(
                              isScanning
                                  ? "Scan en cours..."
                                  : "Scanner le QR code",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade300)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "ou",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey.shade300)),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  "Saisie manuelle",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 14),
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: tableController,
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Text(
                        "#",
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: confirmManual,
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(34),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check, color: Colors.black),
                          SizedBox(width: 10),
                          Text(
                            "Confirmer",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStep2(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildStepHeader(step2: true),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color.fromARGB(255, 255, 161, 54), Color(0xFFFFC107)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Votre table",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Table #$selectedTable",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Votre commande",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8FFF3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        "${_countArticles()} articles",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2AA55B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Column(
                  children: List.generate(cartItems.length, (i) {
                    final item = cartItems[i];
                    final product = item["product"];
                    final int q = (item["quantity"] as num).toInt();
                    final int price = _productPrice(product);
                    final int subtotal = price * q;
                    return Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF4E0),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  "${i + 1}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFB76D00),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _productName(product),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "×$q",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "${formatCFA(subtotal)} CFA",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        if (i < cartItems.length - 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Divider(color: Colors.grey.shade200),
                          ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Total",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Text(
                      "${formatCFA(totalPrice)} CFA",
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFB00020),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }

  Widget buildBottomCTA() {
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      left: 18,
      right: 18,
      child: ElevatedButton.icon(
        onPressed: _onConfirmAndShowValidated,
        icon: const Icon(
          Icons.check_circle_outline,
          size: 20,
          color: Colors.black,
        ),
        label: const Text(
          "Confirmer la commande",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.4,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Passer la commande",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: currentStep == 1 ? buildStep1(context) : buildStep2(context),
          ),
          if (currentStep == 2) buildBottomCTA(),
        ],
      ),
    );
  }
}
