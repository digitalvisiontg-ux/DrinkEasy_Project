import 'package:drink_eazy/App/Modules/Home/Controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:drink_eazy/App/Component/text_component.dart';
import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:drink_eazy/App/Modules/Home/View/home.dart';

/// --- Carte produit ---
Widget buildProductCard({
  required BuildContext context,
  required Product p,
  required VoidCallback onCartUpdated,
  required Function(int) updateCartCount,
}) {
  final double cardHeight = (p.promotion != null) ? 110 : 90;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: GestureDetector(
      onTap: () async {
        final qty = await showProductDetailBottomSheet(context, p);
        if (qty != null && qty > 0) {
          // Ajouter au panier global
          globalCart.add({'product': p, 'quantity': qty});

          // Mettre à jour l'affichage du compteur panier
          updateCartCount(globalCart.length);
          onCartUpdated();

          showMessageComponent(
            context,
            "${p.name} x$qty ajouté au panier",
            "Produit ajouté",
            false,
          );
        }
      },
      child: Card(
        elevation: 0.2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          color: Colors.white,
          height: cardHeight,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  p.imagepath ?? '',
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    Text(
                      p.boissonType ?? '',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),

                    // 🟢 promotion
                    if (p.promotion != null)
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          p.promotion!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade800,
                          ),
                        ),
                      ),
                    const Spacer(),
                  ],
                ),
              ),
              Column(
                children: [
                  if (p.oldPriceCfa != null)
                    Text(
                      "${formatPrice(p.oldPriceCfa!)} CFA",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.grey,
                      ),
                    ),
                  TextComponent(text: "${formatPrice(p.priceCfa)} CFA"),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

String formatPrice(int price) {
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
