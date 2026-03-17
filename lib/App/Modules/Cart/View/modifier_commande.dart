import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:drink_eazy/Api/models/commande_model.dart';
import 'package:drink_eazy/Api/provider/running_order_provider.dart';
import 'package:drink_eazy/Api/provider/produit_provider.dart';
import 'package:drink_eazy/App/Component/confirm_component.dart';
import 'package:drink_eazy/App/Component/showToast_component.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ModifierCommandePage extends StatefulWidget {
  final CommandeModel commande;

  const ModifierCommandePage({super.key, required this.commande});

  @override
  State<ModifierCommandePage> createState() => _ModifierCommandePageState();
}

class _ModifierCommandePageState extends State<ModifierCommandePage> {
  late List<Map<String, dynamic>> _modifiedItems;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialiser les articles à partir de la commande
    _modifiedItems = widget.commande.produits.map((item) {
      return {
        'produit_id': item.produitId,
        'quantite': item.quantite,
        'name': item.nomProduit,
        'price': item.prixUnitaire,
      };
    }).toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshData();
  }

  void _refreshData() {
    final provider = Provider.of<RunningOrderProvider>(context, listen: false);
    final runningOrder = provider.runningOrder;
    if (runningOrder != null && runningOrder.id == widget.commande.id) {
      setState(() {
        _modifiedItems = runningOrder.produits.map((item) {
          return {
            'produit_id': item.produitId,
            'quantite': item.quantite,
            'name': item.nomProduit,
            'price': item.prixUnitaire,
          };
        }).toList();
      });
    }
  }

  double get _totalPrice {
    return _modifiedItems.fold(0.0, (sum, item) {
      final price = item['price'] as double;
      final qty = item['quantite'] as int;
      return sum + (price * qty);
    });
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

  int get _totalOffered {
    int sum = 0;
    for (final item in _modifiedItems) {
      sum += _offeredCount(item['produit_id'] as int, item['quantite'] as int);
    }
    return sum;
  }

  String _formatPrice(num price) {
    final int value = price.round();
    final s = value.toString();
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

  void _updateQuantity(int index, int change) {
    setState(() {
      final currentQty = _modifiedItems[index]['quantite'] as int;
      final newQty = currentQty + change;
      if (newQty > 0) {
        _modifiedItems[index]['quantite'] = newQty;
      } else {
        _removeItem(index);
      }
    });
  }

  void _removeItem(int index) async {
    final confirm = await showConfirmComponent(
      context,
      title: "Supprimer l'article",
      message: "Voulez-vous retirer cet article de la commande ?",
      confirmText: "Supprimer",
      cancelText: "Annuler",
      confirmColor: Colors.red,
    );

    if (confirm == true) {
      setState(() {
        _modifiedItems.removeAt(index);
      });
    }
  }

  Future<void> _handleUpdate() async {
    if (_modifiedItems.isEmpty) {
      showToastComponent(context, "La commande ne peut pas être vide", isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final provider = Provider.of<RunningOrderProvider>(context, listen: false);
      
      // Préparer les items pour l'API (produit_id, quantite, et quantite_offerte)
      final apiItems = _modifiedItems.map((item) {
        final qty = item['quantite'] as int;
        final offered = _offeredCount(item['produit_id'] as int, qty);
        return {
          'produit_id': item['produit_id'],
          'quantite': qty,
          if (offered > 0) 'quantite_offerte': offered,
        };
      }).toList();

      await provider.updateCommande(
        commande: widget.commande,
        items: apiItems,
      );

      showToastComponent(context, "Commande mise à jour avec succès");
      Get.back(); // Retourner à la page précédente (CommandeValideePage)
    } catch (e) {
      String errorMsg = "Erreur lors de la mise à jour";
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          errorMsg = data['message'];
        } else {
          errorMsg = "Erreur serveur (${e.response?.statusCode})";
        }
      } else {
        errorMsg = e.toString();
      }
      showToastComponent(context, errorMsg, isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text(
          "Modifier la commande",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: _modifiedItems.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  color: Colors.white,
                  child: Row(
                    children: [
                      const Icon(Icons.edit_note_rounded, color: Colors.orange),
                      const SizedBox(width: 10),
                      const Text(
                        "Ajustez vos articles",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${_modifiedItems.length} article${_modifiedItems.length > 1 ? 's' : ''}",
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    itemCount: _modifiedItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      return _buildItemCard(index);
                    },
                  ),
                ),
                _buildSummaryBar(),
              ],
            ),
    );
  }

  Widget _buildItemCard(int index) {
    final item = _modifiedItems[index];
    final String name = item['name'];
    final double price = item['price'];
    final int quantity = item['quantite'] as int;
    final int offered = _offeredCount(item['produit_id'] as int, quantity);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${_formatPrice(price)} CFA",
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.orange,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 24),
                onPressed: () => _removeItem(index),
                tooltip: "Supprimer",
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sous-total: ${_formatPrice(price * quantity)} CFA",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (offered > 0)
                    Text(
                      "Offert: $offered",
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _qtyButton(Icons.remove, () => _updateQuantity(index, -1)),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 24,
                    child: Text(
                      "$quantity",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _qtyButton(Icons.add, () => _updateQuantity(index, 1), isAdd: true),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap, {bool isAdd = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isAdd ? Colors.orange : Colors.white,
            border: Border.all(color: isAdd ? Colors.orange : Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            boxShadow: isAdd
              ? [
                  BoxShadow(
                    color: Colors.orange.shade50.withOpacity(0.8),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
          ),
          child: Icon(
            icon,
            size: 18,
            color: isAdd ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Nouveau total",
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                ),
                Text(
                  "${_formatPrice(_totalPrice)} CFA",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            if (_totalOffered > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Text(
                      'Total Offert : $_totalOffered',
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
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _isLoading ? null : _handleUpdate,
              child: Opacity(
                opacity: _isLoading ? 0.7 : 1.0,
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
                      if (_isLoading)
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      else ...[
                        const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          "Enregistrer les modifications",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.production_quantity_limits,
                size: 60,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "La commande est vide",
              style: TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              "Il semble que vous ayez supprimé tous les articles.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
              label: const Text("Retourner aux détails"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange,
                side: const BorderSide(color: Colors.orange, width: 1.5),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
