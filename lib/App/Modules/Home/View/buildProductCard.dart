import 'package:drink_eazy/Api/models/produit.dart';
import 'package:drink_eazy/App/Component/showToast_component.dart';
import 'package:drink_eazy/App/Component/text_component.dart';
import 'package:drink_eazy/App/Modules/Home/View/productDetailModal.dart';
import 'package:flutter/material.dart';

/// --- Carte produit responsive avec badge et zoom image ---
Widget buildProduitCard({
  required BuildContext context,
  required Produit produit,
  required VoidCallback onCartUpdated,
  required Function(int) updateCartCount,
}) {
  // TODO: remplacer 0 par le vrai compteur depuis ton panier global si nécessaire
  int productCount = 0;

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
            isError: false,
          );
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildCardContent(context, produit),
          if (productCount > 0) _buildCartBadge(productCount),
        ],
      ),
    ),
  );
}

/// --- Carte principale ---
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

/// --- Image du produit avec zoom en Hero ---
Widget _buildProductImage(BuildContext ctx, Produit produit, double imageSize) {
  return GestureDetector(
    onTap: () {
      if (produit.imageUrl != null && produit.imageUrl!.isNotEmpty) {
        showDialog(
          context: ctx,
          builder: (_) => Dialog(
            backgroundColor: Colors.black.withOpacity(0.8),
            insetPadding: const EdgeInsets.all(10),
            child: Stack(
              children: [
                Hero(
                  tag: produit.imageUrl!,
                  child: InteractiveViewer(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: MediaQuery.of(ctx).size.width * 0.8,
                        height: MediaQuery.of(ctx).size.height * 0.6,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(produit.imageUrl!),
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
          child: (produit.imageUrl == null || produit.imageUrl!.isEmpty)
              ? Container(color: Colors.grey.shade200)
              : Image.network(produit.imageUrl!, fit: BoxFit.cover),
        ),
      ),
    ),
  );
}

/// --- Détails du produit (titre, type, promo) ---
Widget _buildProductDetails(Produit produit) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        produit.taille != null ?
          Text(
            '${produit.nomProd} (${produit.taille!})',
            maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        
          ) : Text(
          produit.nomProd,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        if (produit.categorieNom != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              produit.categorieNom!,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.red.shade800),
            ),
          ),
      ],
    ),
  );
}

/// --- Prix du produit ---
Widget _buildProductPrice(Produit produit) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      TextComponent(text: "${produit.prixBase.toStringAsFixed(0)} CFA"),
    ],
  );
}

/// --- Badge rouge du panier ---
Widget _buildCartBadge(int count) {
  return Positioned(
    top: -6,
    right: 0,
    child: Container(
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
      child: Text(
        '$count',
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

/// --- BottomSheet pour détails du produit ---
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
