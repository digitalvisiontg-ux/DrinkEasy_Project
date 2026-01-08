import 'dart:ui';

import 'package:drink_eazy/Api/models/cart_model.dart';
import 'package:drink_eazy/Api/models/produit.dart';
import 'package:drink_eazy/Api/provider/cartProvider.dart';
import 'package:drink_eazy/App/Component/confirm_component.dart';
import 'package:drink_eazy/App/Component/showToast_component.dart';
import 'package:drink_eazy/App/Modules/Cart/View/PasserCommandePage.dart';
import 'package:drink_eazy/App/Modules/Home/Controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:drink_eazy/App/Modules/Home/View/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  // garde le constructeur simple pour compatibilité ; la source de vérité est le CartProvider
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    // Rien à initialiser ici : les données du panier viennent de CartProvider.
    _pulseController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 700),
          lowerBound: 0.0,
          upperBound: 0.05,
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) _pulseController.reverse();
        });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  double _formatTotalPrice(List<CartItem> items) {
    return items.fold<double>(0.0, (sum, item) => sum + (item.produit.prixFinal * item.quantite));
  }

  void _updateQuantity(CartProvider cart, CartItem item, int change) {
    final newQty = item.quantite + change;
    if (newQty <= 0) {
      cart.removeFromCart(item.produit);
      showToastComponent(context, "Article supprimé du panier");
    } else {
      cart.updateQuantity(item.produit, newQty);
    }
    _pulseController.forward(from: 0);
  }

  void _removeItem(CartProvider cart, CartItem item) {
    cart.removeFromCart(item.produit);
    showToastComponent(context, "Article supprimé du panier", isError: false);
    _pulseController.forward(from: 0);
  }

  Future<void> _clearCart(CartProvider cart) async {
    if (cart.isEmpty) {
      showToastComponent(
        context,
        "Votre panier est déjà vide",
        isError: false,
        gravity: ToastGravity.TOP_RIGHT,
      );
      return;
    }

    final confirm = await showConfirmComponent(
      context,
      title: "Confirmation",
      message: "Voulez-vous vraiment vider le panier ?",
      confirmText: "Vider",
      cancelText: "Annuler",
      confirmColor: Colors.red,
      cancelColor: Colors.grey.shade200,
      icon: Icons.delete_sweep_outlined,
      iconColor: Colors.red,
      iconBgColor: Colors.redAccent.withOpacity(0.1),
    );

    if (confirm == true) {
      cart.clearCart();
      showToastComponent(context, "Le panier a été vidé avec succès");
    }
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

  Widget _styledQtyButton(IconData icon, VoidCallback onTap, { required bool isAdd }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          gradient: isAdd
              ? LinearGradient(
                  colors: [Colors.orange.shade600, Colors.orange.shade400],
                )
              : null,
          color: isAdd ? null : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: isAdd
              ? [
                  BoxShadow(
                    color: Colors.orange.shade50.withOpacity(0.8),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          color: isAdd ? Colors.white : Colors.black54,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildProductCard(CartItem item, int index, CartProvider cart) {
    final Produit product = item.produit;
    final int quantity = item.quantite;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 450),
      builder: (context, val, child) {
        return Opacity(
          opacity: val,
          child: Transform.translate(
            offset: Offset(0, (1 - val) * 6),
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.white,
        elevation: 6,
        shadowColor: Colors.black12,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    // IMAGE
                    Container(
                      width: MediaQuery.of(context).size.width / 5,
                      height: MediaQuery.of(context).size.width / 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                            ? (product.imageUrl!.startsWith('http')
                                ? Image.network(
                                    product.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.local_drink,
                                      size: 36,
                                      color: Colors.grey,
                                    ),
                                  )
                                : Image.asset(
                                    product.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.local_drink,
                                      size: 36,
                                      color: Colors.grey,
                                    ),
                                  ))
                            : const Icon(
                                Icons.local_drink,
                                size: 36,
                                color: Colors.grey,
                              ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // INFOS PRODUIT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  product.nomProd,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "${_formatPrice(product.prixFinal)} CFA",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 8), 

                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  product.categorie?.nomCat ?? '',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Spacer(),

                              Row(
                                children: [
                                  _styledQtyButton(Icons.remove, () {
                                    _updateQuantity(cart, item, -1);
                                  }, isAdd: false),
                                  const SizedBox(width: 10),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (child, anim) =>
                                        ScaleTransition(scale: anim, child: child),
                                    child: Text(
                                      "$quantity",
                                      key: ValueKey<int>(quantity),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  _styledQtyButton(Icons.add, () {
                                    _updateQuantity(cart, item, 1);
                                  }, isAdd: true),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          if (quantity > 1) ...[
                            Row(
                              children: [
                                const Text(
                                  "Sous-total:",
                                  style: TextStyle(
                                    color: Color(0xFF757575),
                                    fontSize: 13,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  " ${_formatPrice(product.prixFinal * quantity)} CFA",
                                  style: const TextStyle(
                                    color: Color(0xFF757575),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),

                            // Afficher le nombre d'articles offerts pour ce produit si éligible
                            Builder(builder: (ctx) {
                              final offered = cart.offeredCountForProduct(product.id);
                              return offered > 0
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Offert : $offered',
                                            style: TextStyle(
                                              color: Colors.green.shade700,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink();
                            }),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                InkWell(
                  onTap: () => _removeItem(cart, item),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(width: 6),
                        const Text("Supprimer", style: TextStyle(color: Colors.red)),
                      ],
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

  Widget _buildEmptyCart(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 180,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.remove_shopping_cart,
                size: 80,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              "Votre panier est vide",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              "Ajoutez des boissons pour commencer votre commande !",
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () {
                Get.offAll(() => const Home());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 12,
                ),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Découvrir les produits",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme, CartProvider cart) {
    final items = cart.itemsList;
    final total = _formatTotalPrice(items);
    final offeredCount = cart.totalOfferedProducts;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Total à payer",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "${_formatPrice(total)} CFA",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                                const SizedBox(height: 4),
                                if (offeredCount > 0)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Total Offert : $offeredCount',
                                          style: TextStyle(
                                            color: Colors.green.shade700,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                        ],
                      ),
                      _checkoutButton(cart),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 16,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Paiement sécurisé",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔥🔥🔥 _checkoutButton entièrement corrigé 🔥🔥🔥
  Widget _checkoutButton(CartProvider cart) {
    return GestureDetector(
      onTap: () {
        Get.to(() => PasserCommandePage(cartItems: globalCart));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF8A00), Color(0xFFFFC107)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.shade50.withOpacity(0.6),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            const Text(
              "Valider la commande",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.watch<CartProvider>();
    final items = cart.itemsList;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          "Mon panier",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _clearCart(cart),
            icon: const Icon(
              Icons.delete_sweep_outlined,
              color: Colors.redAccent,
            ),
            tooltip: "Vider le panier",
          ),
        ],
      ),
      body: Column(
        children: [
          // header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFF8E1), Color(0xFFFFFFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart_outlined, color: Colors.orange),
                const SizedBox(width: 10),
                const Text(
                  "Votre panier",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Chip(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  backgroundColor: Colors.orange.shade50,
                  label: Text(
                    "${items.length} article${items.length > 1 ? 's' : ''}",
                    style: const TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: items.isEmpty ? _buildEmptyCart(theme) : _buildCartList(theme, cart),
          ),

          _buildBottomBar(theme, cart),
        ],
      ),
    );
  }

  Widget _buildCartList(ThemeData theme, CartProvider cart) {
    final items = cart.itemsList;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildProductCard(item, index, cart);
        },
      ),
    );
  }
}