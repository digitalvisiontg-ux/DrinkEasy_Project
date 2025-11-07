import 'package:drink_eazy/Api/models/produit.dart';
import 'package:drink_eazy/App/Component/text_component.dart';
import 'package:flutter/material.dart';

class ProductDetailBottomSheet extends StatefulWidget {
  final Produit produit;
  const ProductDetailBottomSheet({super.key, required this.produit});

  @override
  State<ProductDetailBottomSheet> createState() => _ProductDetailBottomSheetState();
}

class _ProductDetailBottomSheetState extends State<ProductDetailBottomSheet> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final total = widget.produit.prixBase * quantity;

    return Material(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 200,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Hauteur dynamique
            children: [
              // Barre de glissement
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),

              // Image produit
              GestureDetector(
                onTap: () {
                  if (widget.produit.imageUrl != null &&
                      widget.produit.imageUrl!.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (_) => Dialog(
                        backgroundColor: Colors.black.withOpacity(0.8),
                        insetPadding: const EdgeInsets.all(10),
                        child: Stack(
                          children: [
                            Hero(
                              tag: widget.produit.imageUrl ?? widget.produit.nomProd,
                              child: InteractiveViewer(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: widget.produit.imageUrl != null
                                      ? Image.network(
                                          widget.produit.imageUrl!,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          color: Colors.grey.shade200,
                                        ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: const CircleAvatar(
                                  backgroundColor: Colors.black54,
                                  child: Icon(Icons.close, color: Colors.white),
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
                  tag: widget.produit.imageUrl ?? widget.produit.nomProd,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: widget.produit.imageUrl != null
                        ? Image.network(
                            widget.produit.imageUrl!,
                            height: 160,
                            width: 160,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 160,
                            width: 160,
                            color: Colors.grey.shade200,
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Nom produit
              widget.produit.taille != null ?
          Text(
            '${widget.produit.nomProd} (${widget.produit.taille!})',
            maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        
          ) : Text(
          widget.produit.nomProd,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
              const SizedBox(height: 10),

              // Catégorie
              if (widget.produit.categorieNom != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.produit.categorieNom!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              const SizedBox(height: 16),

              // Prix
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextComponent(
                    text: "${widget.produit.prixBase.toStringAsFixed(0)} CFA",
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Description
              if (widget.produit.descProd != null && widget.produit.descProd!.isNotEmpty)
                Column(
                  children: [
                    Text(
                      widget.produit.descProd!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),

              // Quantité
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Quantité", style: TextStyle(fontWeight: FontWeight.w600)),
                  Row(
                    children: [
                      _qtyButton(Icons.remove, () {
                        if (quantity > 1) setState(() => quantity--);
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '$quantity',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                      _qtyButton(Icons.add, () {
                        setState(() => quantity++);
                      }),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total", style: TextStyle(fontWeight: FontWeight.w600)),
                  TextComponent(text: "${total.toStringAsFixed(0)} CFA"),
                ],
              ),

              const SizedBox(height: 20),
      // Bouton Ajouter au panier
      SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, quantity),
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            label: Text(
              quantity > 1 ? 'Ajouter ($quantity)' : 'Ajouter au panier',
              style: const TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ),
            ],
          ),
        ),
      ),
    );
  }

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
}
