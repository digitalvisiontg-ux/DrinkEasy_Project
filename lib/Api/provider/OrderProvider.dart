import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class OrderProvider extends ChangeNotifier {
  /// --- TABLE ---
  String? _tableRaw; // token ou numero_table

  String get tableLabel => _tableRaw ?? '';
  bool get hasTable => _tableRaw != null;

  void setTableRaw(String value) {
    _tableRaw = value;
    notifyListeners();
  }

  /// --- ITEMS ---
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void setItems(List<CartItem> items) {
    _items = List.from(items);
    notifyListeners();
  }

  /// --- TOTAL ---
  double get totalPrice =>
      _items.fold(0, (sum, e) => sum + e.subtotal);

  /// --- RESET ---
  void clearOrder() {
    _tableRaw = null;
    _items.clear();
    notifyListeners();
  }
}
