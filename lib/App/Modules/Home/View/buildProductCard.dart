import 'package:drink_eazy/App/Modules/Home/Controller/controller.dart';
import 'package:drink_eazy/App/Modules/Home/View/home.dart';
import 'package:drink_eazy/App/Component/text_component.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

/// --- Carte produit responsive avec badge et zoom image ---
Widget buildProductCard({
  required BuildContext context,
  required Product p,
  required VoidCallback onCartUpdated,
  required Function(int) updateCartCount,
}) {
  // Compte combien de fois ce produit est déjà dans le panier
  int productCount = globalCart
      .where((item) => item['product'].name == p.name)
      .fold<int>(0, (sum, item) => sum + (item['quantity'] as int));

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: GestureDetector(
      onTap: () async {
        final qty = await showProductDetailBottomSheet(context, p);
        if (qty != null && qty > 0) {
          globalCart.add({'product': p, 'quantity': qty});
          updateCartCount(globalCart.length);
          onCartUpdated();

          // Afficher un message de confirmation par getx
          Get.snackbar(
            'Produit ajouté',
            '${p.name} x$qty a été ajouté au panier.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          );
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// --- Carte principale ---
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0.2,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxW = constraints.maxWidth;
                  final imageSize = (maxW * 0.18).clamp(56.0, 88.0);
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // --- Image circulaire cliquable ---
                      GestureDetector(
                        onTap: () {
                          if (p.imagepath != null && p.imagepath!.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                backgroundColor: Colors.black.withOpacity(0.8),
                                insetPadding: const EdgeInsets.all(10),
                                child: Stack(
                                  children: [
                                    Hero(
                                      tag: p.imagepath!,
                                      child: InteractiveViewer(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(p.imagepath!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.8,
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.6,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        child: GestureDetector(
                                          onTap: () =>
                                              Navigator.of(context).pop(),
                                          child: const Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                        child: Hero(
                          tag: p.imagepath ?? p.name,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: SizedBox(
                              width: imageSize,
                              height: imageSize,
                              child:
                                  (p.imagepath == null || p.imagepath!.isEmpty)
                                  ? Container(color: Colors.grey.shade200)
                                  : Image.asset(
                                      p.imagepath!,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // --- Texte principal (titre + type + promo) ---
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              p.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              p.boissonType ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            if (p.promotion != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade100,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  p.promotion!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red.shade800,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      // --- Prix (aligné à droite) ---
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (p.oldPriceCfa != null)
                            Text(
                              "${formatPrice(p.oldPriceCfa!)} CFA",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          SizedBox(height: p.oldPriceCfa != null ? 4 : 0),
                          TextComponent(text: "${formatPrice(p.priceCfa)} CFA"),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          /// --- Badge rouge du panier ---
          if (productCount > 0)
            Positioned(
              top: -6,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$productCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

/// --- Format prix ---
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
