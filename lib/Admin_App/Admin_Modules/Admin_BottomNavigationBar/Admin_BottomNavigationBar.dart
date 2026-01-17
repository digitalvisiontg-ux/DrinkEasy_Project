import 'package:drink_eazy/Utils/colors.dart';
import 'package:flutter/material.dart';

Widget bottomNav() {
  return BottomNavigationBar(
    currentIndex: 0,
    selectedItemColor: primary,
    unselectedItemColor: Colors.grey,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Produits'),
      BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Commandes'),
      BottomNavigationBarItem(
        icon: Icon(Icons.local_offer),
        label: 'Promotions',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.bar_chart),
        label: 'Statistiques',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
    ],
  );
}
