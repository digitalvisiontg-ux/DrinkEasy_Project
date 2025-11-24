import 'package:drink_eazy/Api/models/produit.dart';
import 'package:drink_eazy/Api/provider/cartProvider.dart';
import 'package:drink_eazy/App/Component/text_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailBottomSheet extends StatefulWidget {
  final Produit produit;
  const ProductDetailBottomSheet({super.key, required this.produit});

  @override
  State<ProductDetailBottomSheet> createState() => _ProductDetailBottomSheetState();
}

class _ProductDetailBottomSheetState extends State<ProductDetailBottomSheet>
    with SingleTickerProviderStateMixin {
  int quantity = 1;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Retourne la promotion active en excluant certains types si nécessaire
  Promotion? getActivePromotion(Produit produit) {
    final filtered = produit.promotionsDetails
        .where((promo) => !promo.texteBadge.toLowerCase().contains('happy house'))
        .toList();
    return filtered.isNotEmpty ? filtered.first : null;
  }

  @override
  Widget build(BuildContext context) {
    final activePromotion = getActivePromotion(widget.produit);
    double prixUnitaire = widget.produit.prixFinal;
    double total = prixUnitaire * quantity;
  int freeCount = 0;
    String? congratulationMessage;

  // (offerThreshold not needed here; debug helper uses its own parsing)

  // Normaliser le type de réduction pour comparaisons insensibles à la casse
  final promoType = activePromotion?.typeReduction?.toLowerCase();
  final isNAchatNOffert = activePromotion?.type == "achat_offert";
  // Quantité déjà présente dans le panier pour ce produit (mise à jour automatique via Provider)
  // Quantité déjà présente dans le panier pour ce produit (mise à jour automatique via Provider)

    // Calcul du prix selon type de promotion
    if (activePromotion != null && promoType != null) {
      switch (promoType) {
        case 'pourcentage':
          if (activePromotion.valeurReduction != null) {
            final reduction = prixUnitaire * (activePromotion.valeurReduction! / 100);
            prixUnitaire -= reduction;
            total = prixUnitaire * quantity;
          }
          break;
  case 'montantfixe':
          if (activePromotion.valeurReduction != null) {
            prixUnitaire -= activePromotion.valeurReduction!;
            total = prixUnitaire * quantity;
          }
          break;
        default:
          break;
      }
    }

    // Calculer le nombre de produits offerts à partir de la quantité déjà dans le panier
    if (isNAchatNOffert &&
        activePromotion?.quantiteAchat != null &&
        activePromotion?.quantiteOfferte != null) {

      final n = activePromotion!.quantiteAchat!;
      final offert = activePromotion.quantiteOfferte!;

      // freeCount correspond au nombre d'articles offerts calculé sur la quantité en panier
      freeCount = (quantity ~/ n) * offert;
    }

    if (isNAchatNOffert && freeCount > 0) {
      congratulationMessage =
          "🎉 Félicitations ! Vous recevrez $freeCount produit${freeCount > 1 ? 's' : ''} gratuit${freeCount > 1 ? 's' : ''} !";
    }

    return FractionallySizedBox(
      heightFactor: 0.78,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: LayoutBuilder(
            builder: (context, constraints) => Column(
              children: [
                // --- Contenu scrollable ---
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // --- Barre du haut ---
                        Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // --- Image produit ---
                        _buildProductImage(context),

                        const SizedBox(height: 15),

                        // --- Nom produit ---
                        Text(
                          widget.produit.taille != null
                              ? '${widget.produit.nomProd} (${widget.produit.taille!})'
                              : widget.produit.nomProd,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),

                        // --- Catégorie ---
                        if (widget.produit.categorie?.nomCat != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.produit.categorie!.nomCat,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        const SizedBox(height: 16),

                        // --- Prix ---
                        _buildPriceRow(prixUnitaire),

                        const SizedBox(height: 15),

                        // --- Description ---
                        if (widget.produit.descProd?.isNotEmpty ?? false)
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

                        // --- Promotion ---
                        if (activePromotion != null)
                          _buildPromotion(activePromotion.texteBadge),

                        if (congratulationMessage != null) ...[
                          const SizedBox(height: 10),
                          _buildCongratulationMessage(congratulationMessage),
                        ],

                        const SizedBox(height: 15),

                        // --- Quantité ---
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Quantité", style: TextStyle(fontWeight: FontWeight.w600)),
                                Row(
                                  children: [
                                    _qtyButton(Icons.remove, () {
                                      if (quantity > 1) {
                                        setState(() {
                                          quantity--;
                                        });
                                        _debugLog();
                                      }
                                    }),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Text('$quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                                    ),
                                    _qtyButton(Icons.add, () {
                                      setState(() {
                                        quantity++;
                                      });
                                      _debugLog();
                                    }),
                                  ],
                                ),
                              ],
                            ),
                            // Quantité déjà dans le panier (mise à jour automatique) - affichée sous le sélecteur
                            Builder(
                              builder: (ctx) {
                                final inCartLocal = Provider.of<CartProvider>(ctx).getItemByProductId(widget.produit.id)?.quantite ?? 0;
                                return inCartLocal > 0
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          'Quantité totale dans le panier : $inCartLocal',
                                          style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              },
                            ),
                            
                            if (isNAchatNOffert)
                              Builder(
                                builder: (ctx) {
                                  // Re-lire la quantité en panier localement pour réagir aux changements du provider
                                  final inCartLocal = Provider.of<CartProvider>(ctx).getItemByProductId(widget.produit.id)?.quantite ?? 0;
                                  if (activePromotion?.quantiteAchat != null && activePromotion?.quantiteOfferte != null) {
                                    final n = activePromotion!.quantiteAchat!;
                                    final offert = activePromotion.quantiteOfferte!;
                                    final freeFromCart = (inCartLocal ~/ n) * offert;
                                    return freeFromCart > 0
                                        ? Padding(
                                            padding: const EdgeInsets.only(top: 6),
                                            child: Text(
                                              "🎉 Vous aurez $freeFromCart produit${freeFromCart > 1 ? 's' : ''} offert${freeFromCart > 1 ? 's' : ''} !",
                                              style: TextStyle(
                                                color: Colors.green.shade700,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink();
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),

                        // --- Total ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total", style: TextStyle(fontWeight: FontWeight.w600)),
                            TextComponent(text: "${total.toStringAsFixed(0)} CFA"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // --- Bouton fixe en bas ---
                SafeArea(
                  top: false,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Ajoute au panier via le provider puis renvoie la quantité au caller
                        context.read<CartProvider>().addToCart(widget.produit, quantity);
                        Navigator.pop(context, quantity);
                      },
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
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.produit.imageUrl?.isNotEmpty ?? false) {
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
                        child: Image.network(
                          widget.produit.imageUrl!,
                          fit: BoxFit.cover,
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
              : Container(height: 160, width: 160, color: Colors.grey.shade200),
        ),
      ),
    );
  }

  Widget _buildPriceRow(double prixUnitaire) {
    final hasDiscount = widget.produit.prixFinal != widget.produit.prixBase;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (hasDiscount)
          Text(
            "${widget.produit.prixBase.toStringAsFixed(0)} CFA",
            style: const TextStyle(
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
              fontSize: 14,
            ),
          ),
        if (hasDiscount) const SizedBox(width: 8),
        TextComponent(text: "${prixUnitaire.toStringAsFixed(0)} CFA"),
      ],
    );
  }

  Widget _buildPromotion(String promo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber, width: 1),
      ),
      child: Text(
        promo,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }

  Widget _buildCongratulationMessage(String msg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green, width: 1),
      ),
      child: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
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

  // Méthode de debug temporaire pour afficher en console l'état des promos/quantités
  void _debugLog() {
    try {
      final p = widget.produit;
      final promo = getActivePromotion(p);
      final threshold = _getOfferThreshold(promo?.texteBadge);
      int free = 0;
      final promoType = promo?.typeReduction?.toLowerCase();
      final promoIsNAchat = promoType == 'nachatnoffert' || (promoType?.contains('achat') == true && promoType?.contains('offert') == true);
      if (promo != null && promoIsNAchat && threshold != null && promo.quantiteOfferte != null) {
        free = (quantity ~/ threshold) * promo.quantiteOfferte!;
      }
      debugPrint('DEBUG Produit: id=${p.id}, qty=$quantity, promo=${promo?.typeReduction}, threshold=$threshold, quantiteOfferte=${promo?.quantiteOfferte}, free=$free');
    } catch (e) {
      debugPrint('DEBUG log error: $e');
    }
  }

  int? _getOfferThreshold(String? promotionText) {
    if (promotionText == null) return null;
  final regex = RegExp(r"Achetez\s*(\d+)", caseSensitive: false);
    final match = regex.firstMatch(promotionText);
    return match != null ? int.tryParse(match.group(1)!) : null;
  }
}
