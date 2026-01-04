import 'package:drink_eazy/App/Component/confirm_component.dart';
import 'package:drink_eazy/App/Component/showToast_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key});

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
    final args = Get.arguments as Map<String, dynamic>;

    final int tableNumber = args["tableNumber"];
    final String orderId = args["orderId"];
    final List cartItems = args["items"];
    final int totalPrice = args["totalPrice"];
    final String status = args["status"];

    Color statusColor() {
      switch (status) {
        case "Prête":
          return Colors.green;
        case "Livrée":
          return Colors.grey;
        default:
          return const Color(0xFF2F6FED);
      }
    }

    String estimateTime() {
      if (status == "En préparation") return "10-20 min";
      if (status == "Prête") return "Disponible";
      return "-";
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
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
              "orderId": orderId,
              "items": cartItems,
              "totalPrice": totalPrice,
              "status": "En préparation",
            },
          ),
        ),
        title: const Text(
          "Détails de la commande",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: _infoCard(
                  icon: Icons.tag,
                  iconBg: const Color(0xFFFFF2CC),
                  title: "Commande",
                  value: "$orderId",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _infoCard(
                  icon: Icons.restaurant_menu,
                  iconBg: const Color(0xFFDFFFE9),
                  title: "Table",
                  value: "#$tableNumber",
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusColor(),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.access_time, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Statut",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    Text(
                      status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "Temps estimé",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    Text(
                      estimateTime(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // -------------------------
          // 🧾 ARTICLES
          // -------------------------
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Articles commandés",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
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
                          color: Color(0xFF2AA55B),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                ...cartItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final product = item["product"];
                  final qty = item["quantity"];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
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
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                "Quantité: $qty",
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
                            color: Color(0xFFB00020),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const Divider(height: 28),

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
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFB00020),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // -------------------------
          // 🟡 MODIFIER
          // -------------------------
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.edit, color: Colors.black),
              label: const Text(
                "Modifier la commande",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD73C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () async {
                final confirm = await showConfirmComponent(
                  context,
                  title: "Annuler la commande",
                  message: "Êtes-vous sûr de vouloir annuler votre commande ?",
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
                  showToastComponent(context, "Commande annulée avec succès.");
                }
              },
              icon: const Icon(Icons.close, color: Color(0xFFB00020)),
              label: const Text(
                "Annuler la commande",
                style: TextStyle(
                  color: Color(0xFFB00020),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFB00020), width: 1.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 15, color: Colors.black87),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
