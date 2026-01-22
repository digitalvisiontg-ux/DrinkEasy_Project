// import 'package:drink_eazy/Admin_App/Admin_Modules/AdminOrdersPage.dart/AdminOrdersPage.dart';
// import 'package:drink_eazy/Admin_App/Admin_Modules/AdminPromotionsPage/AdminPromotionsPage.dart';
// import 'package:drink_eazy/Admin_App/Admin_Modules/AdminSettingsPage/AdminSettingsPage.dart';
// import 'package:drink_eazy/Admin_App/Admin_Modules/AdminStatsPage/AdminStatsPage.dart';
// import 'package:drink_eazy/Admin_App/Admin_Modules/Admin_Products/AdminProductsPage.dart';
// import 'package:drink_eazy/Utils/colors.dart';
// import 'package:flutter/material.dart';

// Widget bottomNav() {
//   return BottomNavigationBar(
//     currentIndex: 0,
//     selectedItemColor: primary,
//     unselectedItemColor: Colors.grey,
//     items: const [
//       BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Produits'),
//       BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Commandes'),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.local_offer),
//         label: 'Promotions',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.bar_chart),
//         label: 'Statistiques',
//       ),
//       BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Paramètres'),
//     ],
//   );
// }

import 'package:drink_eazy/Admin_App/Admin_Modules/AdminOrdersPage.dart/View/AdminOrdersPage.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/AdminPromotionsPage/AdminPromotionsPage.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/AdminSettingsPage/AdminSettingsPage.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/AdminStatsPage/AdminStatsPage.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/Admin_Products/AdminProductsPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:drink_eazy/Utils/colors.dart';

Widget bottomNav({required int currentIndex}) {
  return BottomNavigationBar(
    currentIndex: currentIndex,
    selectedItemColor: primary,
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,

    onTap: (index) {
      if (index == currentIndex) return;

      switch (index) {
        case 0:
          Get.off(() => AdminProductsPage());
          break;
        case 1:
          Get.off(() => AdminOrdersPage());
          break;
        case 2:
          Get.off(() => AdminPromotionsPage());
          break;
        case 3:
          Get.off(() => AdminStatisticsPage());
          break;
        case 4:
          Get.off(() => AdminSettingsPage());
          break;
      }
    },

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
