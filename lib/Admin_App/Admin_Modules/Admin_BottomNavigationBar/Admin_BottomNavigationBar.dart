
import 'package:drink_eazy/Admin_App/Admin_Modules/AdminOrdersPage.dart/View/AdminOrdersPage.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/AdminOrdersPage.dart/Controller/OrdersController.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/AdminPromotionsPage/AdminPromotionsPage.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/AdminSettingsPage/AdminSettingsPage.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/AdminStatsPage/AdminStatsPage.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/Admin_Products/AdminProductsPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget bottomNav({required int currentIndex}) {
  // S'assurer que le controller est initialisé
  final ordersController = Get.isRegistered<AdminOrdersController>()
      ? Get.find<AdminOrdersController>()
      : null;

  return BottomNavigationBar(
    currentIndex: currentIndex,
    selectedItemColor: const Color.fromARGB(255, 37, 99, 235),
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

    items: [
      const BottomNavigationBarItem(
        icon: Icon(Icons.inventory_2_outlined),
        label: 'Produits',
      ),
      BottomNavigationBarItem(
        icon: _buildOrdersIconWithBadge(ordersController),
        label: 'Commandes',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.local_offer_outlined),
        label: 'Promotions',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.bar_chart_outlined),
        label: 'Statistiques',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.settings_outlined),
        label: 'Paramètres',
      ),
    ],
  );
}

Widget _buildOrdersIconWithBadge(AdminOrdersController? controller) {
  if (controller == null) {
    return const Icon(Icons.receipt_outlined);
  }

  return Obx(() {
    final pendingCount = controller.orders
        .where((order) => order['status'] == 'pending')
        .length;

    if (pendingCount == 0) {
      return const Icon(Icons.receipt_outlined);
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.receipt_outlined),
        Positioned(
          right: -8,
          top: -8,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              pendingCount > 99 ? '99+' : pendingCount.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  });
}
