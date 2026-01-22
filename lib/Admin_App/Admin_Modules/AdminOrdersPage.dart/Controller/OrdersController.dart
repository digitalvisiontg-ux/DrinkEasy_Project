/* =========================================================
   CONTROLLER GETX – COMMANDES AVEC FILTRES
   ========================================================= */

import 'package:drink_eazy/Admin_App/Admin_Modules/Admin_Json/Admin_Order_Json.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AdminOrdersController extends GetxController {
  var orders = <Map<String, dynamic>>[].obs;
  var search = ''.obs;
  var showFilters = false.obs;

  // Filtres
  var statusFilter = 'Tous'.obs;
  var tableFilter = 'Toutes'.obs;
  var dateFilter = 'Toutes'.obs;
  var amountFilter = 'Tous'.obs;

  @override
  void onInit() {
    orders.assignAll(ordersJson);
    super.onInit();
  }

  int get filteredCount => filteredOrders.length;

  List<Map<String, dynamic>> get filteredOrders {
    return orders.where((o) {
      // Recherche
      final q = search.value.toLowerCase();
      final matchSearch =
          o['customer'].toLowerCase().contains(q) ||
          o['id'].toLowerCase().contains(q) ||
          o['table'].toLowerCase().contains(q);

      // Filtre Statut
      final matchStatus =
          statusFilter.value == 'Tous' ||
          (statusFilter.value == 'En attente' && o['status'] == 'pending') ||
          (statusFilter.value == 'Confirmée' && o['status'] == 'confirmed') ||
          (statusFilter.value == 'Refusée' && o['status'] == 'refused');

      // Filtre Table
      final matchTable =
          tableFilter.value == 'Toutes' || o['table'] == tableFilter.value;

      // Filtre Montant
      bool matchAmount = true;
      if (amountFilter.value != 'Tous') {
        final amount = o['amount'] as int;
        switch (amountFilter.value) {
          case 'Moins de 5000':
            matchAmount = amount < 5000;
            break;
          case '5000 - 10000':
            matchAmount = amount >= 5000 && amount <= 10000;
            break;
          case 'Plus de 10000':
            matchAmount = amount > 10000;
            break;
        }
      }

      return matchSearch && matchStatus && matchTable && matchAmount;
    }).toList();
  }

  void resetFilters() {
    statusFilter.value = 'Tous';
    tableFilter.value = 'Toutes';
    dateFilter.value = 'Toutes';
    amountFilter.value = 'Tous';
  }

  void confirmOrder(String id) {
    final index = orders.indexWhere((o) => o['id'] == id);
    if (index != -1) {
      orders[index]['status'] = 'confirmed';
      orders.refresh();
      Get.snackbar(
        'Succès',
        'Commande confirmée',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    }
  }

  void refuseOrder(String id) {
    final index = orders.indexWhere((o) => o['id'] == id);
    if (index != -1) {
      orders[index]['status'] = 'refused';
      orders.refresh();
      Get.snackbar(
        'Commande refusée',
        'La commande a été refusée',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    }
  }
}
