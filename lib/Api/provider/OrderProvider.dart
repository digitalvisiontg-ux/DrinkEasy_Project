import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class OrderProvider extends ChangeNotifier {
  /// ===============================
  /// TABLE
  /// ===============================

  String? _tableRaw;    // numero_table (technique)
  String? _tableLabel;  // libellé business (affichage)

  /// Données exposées
  String get tableRaw => _tableRaw ?? '';
  String get tableLabel => _tableLabel ?? '';

  bool get hasTable => _tableRaw != null;

  /// Setters
  void setTableRaw(String value) {
    _tableRaw = value;
    notifyListeners();
  }

  void setTableLabel(String value) {
    _tableLabel = value;
    notifyListeners();
  }

  /// ===============================
  /// ITEMS
  /// ===============================

  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void setItems(List<CartItem> items) {
    _items = List.from(items);
    notifyListeners();
  }

  /// ===============================
  /// TOTAL
  /// ===============================

  double get totalPrice =>
      _items.fold(0, (sum, e) => sum + e.subtotal);

  /// ===============================
  /// RESET
  /// ===============================

  void clearOrder() {
    _tableRaw = null;
    _tableLabel = null;
    _items.clear();
    notifyListeners();
  }
}