import 'package:drink_eazy/Api/models/produit.dart';
import 'package:drink_eazy/Api/provider/cartProvider.dart';
import 'package:drink_eazy/App/Component/showToast_component.dart';
import 'package:drink_eazy/App/Component/text_component.dart';
import 'package:drink_eazy/App/Modules/Home/View/productDetailModal.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

/// --- Carte produit responsive avec front-end A et backend B ---
Widget buildProductCard({
  required BuildContext context,
  required Produit produit,
  required VoidCallback onCartUpdated,
  required Function(int) updateCartCount,
  int productCount = 0,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: GestureDetector(
      onTap: () async {
        final qty = await showProductDetailBottomSheet(context, produit);
        if (qty != null && qty > 0) {
          updateCartCount(qty);
          onCartUpdated();
          showToastComponent(
            context,
            "${produit.nomProd} x$qty ajouté au panier.",
            gravity: ToastGravity.BOTTOM,
          );
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildCardContent(context, produit),
          _buildCartBadge(context, produit.id),
        ],
      ),
    ),
  );
}

Widget _buildCardContent(BuildContext context, Produit produit) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              _buildProductImage(context, produit, imageSize),
              const SizedBox(width: 12),
              _buildProductDetails(produit),
              const SizedBox(width: 12),
              _buildProductPrice(produit),
            ],
          );
        },
      ),
    ),
  );
}

Widget _buildProductImage(BuildContext ctx, Produit produit, double imageSize) {
  return GestureDetector(
    onTap: () {
      if (produit.imageUrl?.isNotEmpty ?? false) {
        showDialog(
          context: ctx,
          builder: (_) => Dialog(
            backgroundColor: Colors.black.withOpacity(0.8),
            insetPadding: const EdgeInsets.all(10),
            child: Stack(
              children: [
                Hero(
                  tag: produit.imageUrl ?? produit.nomProd,
                  child: InteractiveViewer(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: MediaQuery.of(ctx).size.width * 0.8,
                        height: MediaQuery.of(ctx).size.height * 0.6,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(produit.imageUrl ?? ''),
                            fit: BoxFit.cover,
                          ),
                        ),
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
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: GestureDetector(
                      onTap: () => Navigator.of(ctx).pop(),
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(Icons.close, color: Colors.white, size: 24),
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
      tag: produit.imageUrl ?? produit.nomProd,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: SizedBox(
          width: imageSize,
          height: imageSize,
          child: (produit.imageUrl?.isEmpty ?? true)
              ? Container(color: Colors.grey.shade200)
              : Image.network(produit.imageUrl!, fit: BoxFit.cover),
        ),
      ),
    ),
  );
}

Widget _buildProductDetails(Produit produit) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          produit.taille != null ? '${produit.nomProd} (${produit.taille})' : produit.nomProd,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        if (produit.categorie?.nomCat != null)
         Text(
              produit.categorie!.nomCat,
              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
            ),
        const SizedBox(height: 6),
        // --- Badge promotion design A ---
        if (produit.promotionActive && produit.promotionsDetails.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              produit.promotionsDetails.first.texteBadge.isNotEmpty
                  ? produit.promotionsDetails.first.texteBadge
                  : produit.promotionsDetails.first.texteDescription,
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
  );
}

Widget _buildProductPrice(Produit produit) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      if (produit.prixFinal != produit.prixBase)
        Text(
          "${produit.prixBase.toStringAsFixed(0)} CFA",
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          ),
        ),
      const SizedBox(height: 4),
      TextComponent(text: "${produit.prixFinal.toStringAsFixed(0)} CFA"),
    ],
  );
}

Widget _buildCartBadge(BuildContext context, int productId) {
  final cartProvider = Provider.of<CartProvider>(context);
  final item = cartProvider.getItemByProductId(productId);
  final qty = item?.quantite ?? 0;
  if (qty <= 0) return const SizedBox.shrink();

  return Positioned(
    top: -6,
    right: 0,
    child: Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
      child: Text(
        '$qty',
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Future<int?> showProductDetailBottomSheet(BuildContext context, Produit produit) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => ProductDetailBottomSheet(produit: produit),
  );
}
