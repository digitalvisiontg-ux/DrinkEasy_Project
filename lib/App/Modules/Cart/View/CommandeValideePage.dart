import 'package:drink_eazy/Api/provider/running_order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/App/Component/confirm_component.dart';
import 'package:drink_eazy/App/Component/showToast_component.dart';
import 'package:drink_eazy/Api/models/commande_model.dart';
import 'package:get/get.dart';

class CommandeValideePage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final int totalPrice;
  final String tableNumber;
  final CommandeModel commande; // Injection de la commande complète

  const CommandeValideePage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.tableNumber,
    required this.commande,
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
    // On injecte la commande validée dans le RunningOrderProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final runningOrderProvider = Provider.of<RunningOrderProvider>(context, listen: false);
      runningOrderProvider.setRunningOrder(commande);
    });

    final int estimatedTime = 14;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
    backgroundColor: Colors.white,
    elevation: 0.4,
    centerTitle: true,
    automaticallyImplyLeading: false, // empêche le back automatique
    leading: IconButton(
      icon: const Icon(Icons.home, color: Colors.black87),
      onPressed: () {
        Get.toNamed('/home');
      },
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
            Image.asset(
              "assets/images/confettis.gif",
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 16),
            const Text(
              "Commande validée !",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Votre commande a été envoyée avec succès",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _infoCard(
              icon: Icons.receipt_long,
              label: "Numéro de commande",
              value: commande.numeroCommande,
            ),
            const SizedBox(height: 14),
            _gradientCard(
              icon: Icons.restaurant_menu,
              title: "Votre table",
              value: "Table : ${commande.tableLibelle}",
              colors: const [
                Color.fromARGB(255, 255, 161, 54),
                Color(0xFFFFC107),
              ],
            ),
            const SizedBox(height: 14),
            _gradientCard(
              icon: Icons.access_time,
              title: "Temps estimé",
              value: "$estimatedTime minutes",
              colors: const [
                Color(0xFF5EA9FF),
                Color(0xFF388BFF),
              ],
            ),
            const SizedBox(height: 16),
            _orderDetails(context),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.offAllNamed('/home');
                },
                icon: const Icon(Icons.edit),
                label: const Text("Modifierr la commande"),
              ),
            ),
            const SizedBox(height: 12),
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
                    icon: Icons.warning_amber_rounded,
                  );

                  if (confirm == true) {
                    final runningOrderProvider =
                        Provider.of<RunningOrderProvider>(context, listen: false);
                    await runningOrderProvider.clearRunningOrder();

                    Get.offAllNamed('/home');
                    showToastComponent(
                      context,
                      "Commande annulée avec succès.",
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                ),
                child: const Text(
                  "Annuler la commande",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Material(
      elevation: 0.4,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.purple),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: Colors.grey)),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradientCard({
    required IconData icon,
    required String title,
    required String value,
    required List<Color> colors,
  }) {
    return Material(
      elevation: 0.4,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white70)),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderDetails(BuildContext context) {
    return Material(
      elevation: 0.4,
      borderRadius: BorderRadius.circular(18),
      child: Container(
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
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                Text("${cartItems.length} articles"),
              ],
            ),
            const SizedBox(height: 12),
            ...cartItems.map((item) {
              final product = item['product'];
              final qty = item['quantity'];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(child: Text(product.nomProd)),
                    Text("×$qty"),
                    const SizedBox(width: 12),
                    Text("${_formatPrice(product.prixFinal.toInt())} CFA"),
                  ],
                ),
              );
            }),
            const Divider(height: 30),
            Row(
              children: [
                const Text("Total"),
                const Spacer(),
                Text(
                  "${_formatPrice(totalPrice)} CFA",
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: Color(0xFFB00020),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
