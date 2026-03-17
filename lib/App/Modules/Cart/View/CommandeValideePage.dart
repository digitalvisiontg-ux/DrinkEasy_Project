import 'package:drink_eazy/Api/provider/running_order_provider.dart';
import 'package:drink_eazy/Api/provider/produit_provider.dart';
import 'package:drink_eazy/App/Modules/Cart/View/modifier_commande.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/App/Component/confirm_component.dart';
import 'package:drink_eazy/App/Component/showToast_component.dart';
import 'package:drink_eazy/Api/models/commande_model.dart';
import 'package:drink_eazy/Api/models/commande_produit_model.dart';
import 'package:get/get.dart';

class CommandeValideePage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final int totalPrice;
  final String tableNumber;
  final CommandeModel commande; // Injection de la commande complète
  final bool isHistory;

  const CommandeValideePage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.tableNumber,
    required this.commande,
    this.isHistory = false,
  });

  @override
  State<CommandeValideePage> createState() => _CommandeValideePageState();
}

class _CommandeValideePageState extends State<CommandeValideePage> {
  @override
  void initState() {
    super.initState();
    if (!widget.isHistory) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final runningOrderProvider = Provider.of<RunningOrderProvider>(
          context,
          listen: false,
        );
        runningOrderProvider.setRunningOrder(widget.commande);
      });
    }
  }

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

  int _offeredCount(int productId, int quantity) {
    if (quantity <= 0) return 0;
    try {
      final pp = Provider.of<ProduitProvider>(context, listen: false);
      final p = pp.produits.firstWhere((element) => element.id == productId);
      int total = 0;
      for (final promo in p.promotionsDetails) {
        if (promo.type.toLowerCase() == 'achat_offert' &&
            promo.quantiteAchat != null &&
            promo.quantiteOfferte != null) {
          total += (quantity ~/ promo.quantiteAchat!) * promo.quantiteOfferte!;
          break; // on prend la première applicable
        }
      }
      return total;
    } catch (_) {
      return 0; // Produit possiblement non chargé
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the source of truth dynamically
    CommandeModel displayCommande = widget.commande;

    // 🚨 Actively listen to the RunningOrderProvider so this page rebuilds 
    // even from history if an entry is edited via ModifierCommandePage.
    final provider = Provider.of<RunningOrderProvider>(context);
    
    if (provider.runningOrder != null && provider.runningOrder!.id == widget.commande.id) {
      displayCommande = provider.runningOrder!;
    } else if (provider.userCurrentActiveOrder != null && provider.userCurrentActiveOrder!.id == widget.commande.id) {
      displayCommande = provider.userCurrentActiveOrder!;
    }

    final cartItems = displayCommande.produits.map((item) {
      return {
        'product': item,
        'quantity': item.quantite,
        'offered': _offeredCount(item.produitId, item.quantite),
      };
    }).toList();

    final totalPrice = displayCommande.produits.fold(0, (sum, item) => sum + (item.prixUnitaire * item.quantite).toInt());
    
    int totalOffered = 0;
    for (var item in displayCommande.produits) {
      totalOffered += _offeredCount(item.produitId, item.quantite);
    }

    bool isEnCours = [
      'in_progress', 'pending', 'en_cours', 'en_attente', 'confirmed', 'started', 'ready', 'validée', 'validee'
    ].contains(displayCommande.status.toLowerCase().trim());

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: widget.isHistory,
        leading: widget.isHistory
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Get.back(),
              )
            : IconButton(
                icon: const Icon(Icons.home_outlined, color: Colors.black87),
                onPressed: () {
                  Get.toNamed('/home');
                },
              ),
        title: Text(
          widget.isHistory ? "Détails" : "Retour à l'accueil",
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // Top Icon / Image
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.isHistory 
                    ? Colors.orange.shade50 
                    : Colors.white,
                shape: BoxShape.circle,
                boxShadow: widget.isHistory ? null : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: widget.isHistory
                  ? const Icon(Icons.receipt_long, size: 60, color: Colors.orange)
                  : Image.asset(
                      "assets/images/confettis.gif",
                      width: 80,
                      height: 80,
                    ),
            ),
            const SizedBox(height: 20),
            
            // Header Text
            Text(
              widget.isHistory ? "Détails commande" : "Commande validée !",
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              widget.isHistory
                  ? "Voici le récapitulatif de votre commande"
                  : "Votre commande a été envoyée avec succès",
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Info Cards
            _infoCard(
              icon: Icons.tag,
              label: "Numéro de commande",
              value: displayCommande.numeroCommande,
              iconColor: Colors.orange,
              bgColor: Colors.orange.shade50,
            ),
            const SizedBox(height: 14),
            _infoCard(
              icon: Icons.restaurant_menu,
              label: "Votre table",
              value: "Table : ${displayCommande.tableLibelle}",
              iconColor: Colors.deepOrange,
              bgColor: Colors.deepOrange.shade50,
            ),
            const SizedBox(height: 24),
            
            // Order Details List
            _orderDetails(context, cartItems, totalPrice, totalOffered),
            const SizedBox(height: 32),
            
            // Actions Action
            if (isEnCours) ...[
              _primaryButton(
                label: "Modifier la commande",
                icon: Icons.edit_outlined,
                onPressed: () {
                  Get.to(() => ModifierCommandePage(commande: displayCommande));
                },
              ),
              const SizedBox(height: 16),
              _secondaryButton(
                label: "Annuler la commande",
                icon: Icons.close,
                onPressed: () async {
                  final confirm = await showConfirmComponent(
                    context,
                    title: "Annuler la commande",
                    message: "Êtes-vous sûr de vouloir annuler votre commande ?",
                    confirmText: "Oui",
                    cancelText: "Retour",
                    confirmColor: Colors.red,
                    icon: Icons.warning_amber_rounded,
                  );

                  if (confirm == true) {
                    final runningOrderProvider = Provider.of<RunningOrderProvider>(
                      context,
                      listen: false,
                    );
                    
                    try {
                      // Appel API pour supprimer réellement la commande
                      await runningOrderProvider.deleteCommande(displayCommande);

                      if (widget.isHistory) {
                        Get.back(); // Retour à la liste
                      } else {
                        Get.offAllNamed('/home');
                      }
                      
                      showToastComponent(
                        context,
                        "Commande annulée avec succès.",
                      );
                    } catch (e) {
                      showToastComponent(
                        context,
                        "Erreur lors de l'annulation.",
                        isError: true,
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderDetails(BuildContext context, List<Map<String, dynamic>> cartItems, int totalPrice, int totalOffered) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shopping_bag_outlined, color: Colors.orange, size: 22),
              const SizedBox(width: 10),
              const Text(
                "Détails de la commande",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${cartItems.length} article${cartItems.length > 1 ? 's' : ''}",
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...cartItems.map((item) {
            final product = item['product'] as CommandeProduit;
            final qty = item['quantity'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "x$qty",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.nomProduit,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        if ((item['offered'] as int) > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              "Offert : ${item['offered']}",
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    "${_formatPrice((product.prixUnitaire * qty).toInt())} CFA",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 8),
          Divider(color: Colors.grey.shade200, thickness: 1.5),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                "Total",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
              const Spacer(),
              Text(
                "${_formatPrice(totalPrice)} CFA",
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          if (totalOffered > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Text(
                    'Total Offert : $totalOffered',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _primaryButton({required String label, required IconData icon, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF8A00), Color(0xFFFFC107)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.shade50.withOpacity(0.8),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secondaryButton({required String label, required IconData icon, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.shade100, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.red.shade400, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: Colors.red.shade600,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
