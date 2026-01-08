import 'package:drink_eazy/App/Component/showToast_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:drink_eazy/App/Component/confirm_component.dart';

class CommandeValideePage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final int totalPrice;
  final String tableNumber;

  const CommandeValideePage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.tableNumber,
  });

  String _formatPrice(int price) {
    final s = price.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write(' ');
        count = 0;
      }
    }
    return buffer.toString().split('').reversed.join('');
  }

  @override
  Widget build(BuildContext context) {
    final int estimatedTime = 14;

    final String orderNumber = "#${6000 + DateTime.now().millisecond}";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.4,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.offAllNamed(
            "/home",
            arguments: {
              "tableNumber": tableNumber,
              "orderId": orderNumber,
              "items": cartItems,
              "totalPrice": totalPrice,
              "status": "En préparation",
            },
          ),
        ),
        title: const Text(
          "Retour à l'accueil",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Image.asset("assets/images/confettis.gif", width: 100, height: 100),

            const SizedBox(height: 16),

            const Text(
              "Commande validée !",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Votre commande a été envoyée avec succès",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            Material(
              elevation: 0.4,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1E5FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.receipt_long,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Numéro de commande",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const Spacer(),
                    Text(
                      orderNumber,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // 🟡 Votre table
            Material(
              elevation: 0.4,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 161, 54),
                      Color(0xFFFFC107),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.restaurant_menu,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Votre table",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        Text(
                          "Table #$tableNumber",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // 🔵 Temps estimé
            Material(
              elevation: 0.4,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5EA9FF), Color(0xFF388BFF)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.access_time, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Temps estimé",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        Text(
                          "$estimatedTime minutes",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🧾 Détails de la commande
            Material(
              elevation: 0.4,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Détails de la commande",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8FFE5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${cartItems.length} articles",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2AA55B),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Column(
                      children: List.generate(cartItems.length, (index) {
                        final item = cartItems[index];
                        final product = item["product"];
                        final qty = item["quantity"];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
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
                                    "${index + 1}",
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
                                      product.name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "×$qty",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Text(
                                "${_formatPrice(product.priceCfa)} CFA",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),

                    const Divider(height: 30),

                    Row(
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${_formatPrice(totalPrice)} CFA",
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
            ),

            const SizedBox(height: 20),

            // 🟦 Modifier la commande
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  elevation: 0.3,
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Modifier la commande",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 🔴 Annuler
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final confirm = await showConfirmComponent(
                    context,
                    title: "Annuler la commande",
                    message:
                        "Êtes-vous sûr de vouloir annuler votre commande ?",
                    confirmText: "Oui",
                    cancelText: "Annuler",
                    confirmColor: Colors.red,
                    cancelColor: Colors.grey.shade200,
                    icon: Icons.warning_amber_rounded,
                    iconColor: Colors.red,
                    iconBgColor: Colors.redAccent.withOpacity(0.1),
                  );
                  if (confirm == true) {
                    Get.offAllNamed("/home");
                    showToastComponent(
                      context,
                      "Commande annulée avec succès.",
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0.3,
                  backgroundColor: Colors.red.shade50,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Annuler la commande",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ),

            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       Get.offAllNamed(
            //         "/home",
            //         arguments: {
            //           "tableNumber": tableNumber,
            //           "orderId": orderNumber,
            //           "items": cartItems,
            //           "totalPrice": totalPrice,
            //           "status": "En préparation",
            //         },
            //       );
            //     },
            //     style: ElevatedButton.styleFrom(
            //       elevation: 0.3,
            //       backgroundColor: Colors.green,
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 26,
            //         vertical: 14,
            //       ),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(14),
            //       ),
            //     ),
            //     child: const Text(
            //       "Retour à l'accueil",
            //       style: TextStyle(color: Colors.white, fontSize: 17),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
