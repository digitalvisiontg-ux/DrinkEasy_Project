import 'package:drink_eazy/App/Component/text_component.dart';
import 'package:drink_eazy/App/Modules/Home/View/home.dart';
import 'package:flutter/material.dart';

class ProductDetailBottomSheet extends StatefulWidget {
  final Product product;

  const ProductDetailBottomSheet({super.key, required this.product});

  @override
  State<ProductDetailBottomSheet> createState() =>
      _ProductDetailBottomSheetState();
}

class _ProductDetailBottomSheetState extends State<ProductDetailBottomSheet> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final total = product.priceCfa * quantity;

    // 🔢 Vérifie si la promo est du type "Achetez X, recevez 1 offert"
    int? offerThreshold = _getOfferThreshold(product.promotion);
    int freeCount = 0;
    String? congratulationMessage;

    if (offerThreshold != null) {
      freeCount = (quantity ~/ offerThreshold);
      if (freeCount >= 1) {
        congratulationMessage =
            "🎉 Félicitations ! Vous recevrez $freeCount produit${freeCount > 1 ? 's' : ''} gratuit${freeCount > 1 ? 's' : ''} !";
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Barre du haut
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),

            // --- Image centrée ---
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  product.imagepath ?? '',
                  height: 160,
                  width: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- Nom et catégorie ---
            Text(
              product.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              product.boissonType ?? '',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 10),

            // --- Catégorie badge ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                product.category,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // --- Prix ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (product.oldPriceCfa != null)
                  Text(
                    "${_formatPrice(product.oldPriceCfa!)} CFA",
                    style: const TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                      fontSize: 14,
                    ),
                  ),
                if (product.oldPriceCfa != null) const SizedBox(width: 8),
                TextComponent(text: "${_formatPrice(product.priceCfa)} CFA"),
              ],
            ),

            const SizedBox(height: 10),

            // --- Promotion ---
            if (product.promotion != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber, width: 1),
                ),
                child: Column(
                  children: [
                    Text(
                      product.promotion!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 10),
            if (congratulationMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green, width: 1),
                ),
                child: Text(
                  congratulationMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // --- Description ---
            Text(
              "Savourez votre boisson préférée avec une touche unique. Idéale pour vos moments de détente ou de fête.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
            ),

            const SizedBox(height: 24),

            // --- Quantité ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Quantité",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    _qtyButton(Icons.remove, () {
                      if (quantity > 1) setState(() => quantity--);
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _qtyButton(Icons.add, () {
                      setState(() => quantity++);
                    }),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // --- Total ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextComponent(text: "${_formatPrice(total)} CFA"),
              ],
            ),

            const SizedBox(height: 24),

            // --- Bouton Ajouter ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context, quantity);
                },
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black,
                ),
                label: Text(
                  quantity > 1 ? 'Ajouter ($quantity)' : 'Ajouter au panier',
                  style: const TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
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

  // --- Boutons quantité ---
  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    final isAdd = icon == Icons.add;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: isAdd ? Colors.amber.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }

  // --- Format prix ---
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

  // --- Analyse la promo et renvoie le nombre à atteindre ---
  int? _getOfferThreshold(String? promotionText) {
    if (promotionText == null) return null;
    final regex = RegExp(r"Achetez\s*(\d+)");
    final match = regex.firstMatch(promotionText);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }
}
