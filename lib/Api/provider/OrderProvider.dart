import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class OrderProvider extends ChangeNotifier {
  /* ============================================================
   * TABLE (SOURCE DE VÉRITÉ = table_id)
   * ============================================================ */

  int? _tableId; // ID réel backend
  String? _tableNumero; // numero_table (technique)
  String? _tableLabel; // libellé business

  /// Exposed getters
  int? get tableId => _tableId;
  String get tableNumero => _tableNumero ?? '';
  String get tableLabel => _tableLabel ?? '';
  bool get hasTable => _tableId != null;

  /// Setter unique (atomique)
  void setTable({
    required int tableId,
    required String numeroTable,
    required String libelle,
  }) {
    _tableId = tableId;
    _tableNumero = numeroTable;
    _tableLabel = libelle;
    notifyListeners();
  }

  /* ============================================================
   * ITEMS
   * ============================================================ */

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool get hasItems => _items.isNotEmpty;

  void setItems(List<CartItem> items) {
    _items
      ..clear()
      ..addAll(items);
    notifyListeners();
  }

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearItems() {
    _items.clear();
    notifyListeners();
  }

  /* ============================================================
   * TOTAL
   * ============================================================ */

  double get totalPrice => _items.fold(0.0, (sum, e) => sum + e.subtotal);

  /* ============================================================
   * PAYLOAD API
   * ============================================================ */

  /// Structure EXACTE attendue par Laravel
  Map<String, dynamic> toCommandePayload({String? commentaire}) {
    if (_tableId == null) {
      throw Exception('Aucune table sélectionnée');
    }

    if (_items.isEmpty) {
      throw Exception('Aucun produit dans la commande');
    }

    return {
      'table_id': _tableId,
      'commentaire': commentaire,
      'items': _items.map((e) => e.toApiJson()).toList(),
    };
  }

  /* ============================================================
   * RESET
   * ============================================================ */

  void clearOrder() {
    _tableId = null;
    _tableNumero = null;
    _tableLabel = null;
    _items.clear();
    notifyListeners();
  }
}
