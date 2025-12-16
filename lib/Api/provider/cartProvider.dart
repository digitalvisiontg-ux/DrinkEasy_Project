import 'dart:convert';

import 'package:drink_eazy/Api/models/cart_model.dart';
import 'package:drink_eazy/Api/models/produit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _items = {}; // key = produit.id
  static const _prefsKey = 'drink_eazy_cart_v1';

  // --- getters / vue immuable ---
  List<CartItem> get itemsList => _items.values.toList();
  Map<int, CartItem> get itemsMap => Map.unmodifiable(_items);

  int get totalItems {
    int sum = 0;
    _items.forEach((_, item) => sum += item.quantite);
    return sum;
  }

  double get totalPrice {
    double sum = 0.0;
    _items.forEach((_, item) => sum += item.subtotal);
    return sum;
  }

  bool get isEmpty => _items.isEmpty;

  // --- API public (contrat) ---
  void addToCart(Produit p, int qty) {
    if (qty <= 0) return; // edge-case: rien à faire
    final id = p.id;
    if (_items.containsKey(id)) {
      // incrémente la quantité
      _items[id]!.quantite += qty;
    } else {
      _items[id] = CartItem(produit: p, quantite: qty);
    }
    notifyListeners();
    _saveToPrefs(); // persistance asynchrone fire-and-forget
  }

  void removeFromCart(Produit p) {
    final id = p.id;
    if (_items.containsKey(id)) {
      _items.remove(id);
      notifyListeners();
      _saveToPrefs();
    }
  }

  void updateQuantity(Produit p, int newQty) {
    final id = p.id;
    if (!_items.containsKey(id)) return;
    if (newQty <= 0) {
      _items.remove(id);
    } else {
      _items[id]!.quantite = newQty;
    }
    notifyListeners();
    _saveToPrefs();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    _saveToPrefs();
  }

  // --- utilitaires ---
  bool containsProduct(int productId) => _items.containsKey(productId);
  CartItem? getItemByProductId(int productId) => _items[productId];

  // Nombre total d'articles offerts éligibles selon les promotions "achat_offert"
  int get totalOfferedProducts {
    int total = 0;
    _items.forEach((_, item) {
      final promos = item.produit.promotionsDetails;
      for (final promo in promos) {
        if (promo.type.toLowerCase() == 'achat_offert' &&
            promo.quantiteAchat != null &&
            promo.quantiteOfferte != null) {
          total += (item.quantite ~/ promo.quantiteAchat!) * promo.quantiteOfferte!;
          break; // on prend la première promo applicable pour ce produit
        }
      }
    });
    return total;
  }

  /// Nombre d'articles offerts pour un produit précis dans le panier
  int offeredCountForProduct(int productId) {
    final item = _items[productId];
    if (item == null) return 0;
    int total = 0;
    final promos = item.produit.promotionsDetails;
    for (final promo in promos) {
      if (promo.type.toLowerCase() == 'achat_offert' &&
          promo.quantiteAchat != null &&
          promo.quantiteOfferte != null) {
        total += (item.quantite ~/ promo.quantiteAchat!) * promo.quantiteOfferte!;
        break;
      }
    }
    return total;
  }

  // --- persistence (SharedPreferences) ---
  Future<void> _saveToPrefs() async {
    // Désactivé : ne pas persister le panier localement.
    return Future.value();
  }

  Future<void> loadFromPrefs() async {
    // Méthode laissée pour compatibilité mais sans effet.
    return Future.value();
  }
}