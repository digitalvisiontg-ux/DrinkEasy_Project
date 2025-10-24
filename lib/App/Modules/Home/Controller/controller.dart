// --- Formatage prix ---
import 'package:drink_eazy/App/Modules/Home/View/home.dart';
import 'package:drink_eazy/App/Modules/Home/View/productDetailModal.dart';
import 'package:flutter/material.dart';

String formatPrice(int price) {
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

// --- Modal du produit ---
Future<int?> showProductDetailBottomSheet(
  BuildContext context,
  Product product,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => ProductDetailBottomSheet(product: product),
  );
}

List<Map<String, dynamic>> globalCart = [];
