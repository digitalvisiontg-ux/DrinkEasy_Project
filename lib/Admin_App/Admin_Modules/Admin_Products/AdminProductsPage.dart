import 'package:drink_eazy/Admin_App/Admin_Modules/Admin_BottomNavigationBar/Admin_BottomNavigationBar.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/Admin_Json/Admin_Json.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/Admin_Products/AddProductBottomSheet.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/Admin_Products/EditProductBottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/* =========================================================
   CONTROLLER GETX – LOGIQUE MÉTIER COMPLÈTE
   ========================================================= */

class AdminProductsController extends GetxController {
  var products = <Map<String, dynamic>>[].obs;
  var search = ''.obs;
  var showFilters = false.obs;

  // Filtres de base
  var statusFilter = 'Tous'.obs;
  var categoryFilter = 'Toutes'.obs;

  // Nouveaux filtres selon la maquette
  var dateFilter = 'Toutes'.obs;
  var priceRangeFilter = 'Tous'.obs;
  var stockLevelFilter = 'Tous'.obs;

  @override
  void onInit() {
    products.assignAll(productsJson);
    super.onInit();
  }

  List<Map<String, dynamic>> get filteredProducts {
    return products.where((p) {
      // Recherche par nom
      final matchSearch = p['name'].toLowerCase().contains(
        search.value.toLowerCase(),
      );

      // Filtre Statut
      final matchStatus =
          statusFilter.value == 'Tous' ||
          (statusFilter.value == 'Disponible' && p['status'] == 'available') ||
          (statusFilter.value == 'Indisponible' &&
              p['status'] == 'unavailable');

      // Filtre Catégorie
      final matchCategory =
          categoryFilter.value == 'Toutes' ||
          p['category'] == categoryFilter.value;

      // Filtre Date d'ajout
      bool matchDate = true;
      if (dateFilter.value != 'Toutes') {
        // Logique basée sur votre structure de données
        // À adapter selon vos besoins
        matchDate = true;
      }

      // Filtre Gamme de prix
      bool matchPrice = true;
      if (priceRangeFilter.value != 'Tous') {
        final price = p['priceCfa'] as int;
        switch (priceRangeFilter.value) {
          case 'Moins de 1000':
            matchPrice = price < 1000;
            break;
          case '1000 - 5000':
            matchPrice = price >= 1000 && price <= 5000;
            break;
          case 'Plus de 5000':
            matchPrice = price > 5000;
            break;
        }
      }

      // Filtre Niveau de stock
      bool matchStock = true;
      if (stockLevelFilter.value != 'Tous') {
        final stock = p['stock'] as int;
        switch (stockLevelFilter.value) {
          case 'Faible (< 10)':
            matchStock = stock < 10;
            break;
          case 'Moyen (10-50)':
            matchStock = stock >= 10 && stock <= 50;
            break;
          case 'Élevé (> 50)':
            matchStock = stock > 50;
            break;
        }
      }

      return matchSearch &&
          matchStatus &&
          matchCategory &&
          matchDate &&
          matchPrice &&
          matchStock;
    }).toList();
  }

  void resetFilters() {
    statusFilter.value = 'Tous';
    categoryFilter.value = 'Toutes';
    dateFilter.value = 'Toutes';
    priceRangeFilter.value = 'Tous';
    stockLevelFilter.value = 'Tous';
  }

  void deleteProduct(String id) {
    products.removeWhere((p) => p['id'] == id);
  }

  void toggleProductStatus(String id) {
    final index = products.indexWhere((p) => p['id'] == id);
    if (index == -1) return;

    final current = products[index]['status'];
    products[index]['status'] = current == 'available'
        ? 'unavailable'
        : 'available';

    products.refresh();
  }

  void updateProduct(product, Map<String, Object> map) {}
}

/* =========================================================
   PAGE ADMIN PRODUITS
   ========================================================= */

class AdminProductsPage extends StatelessWidget {
  AdminProductsPage({super.key});

  final controller = Get.put(AdminProductsController());
  final primary = const Color(0xFF2F5BEA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: _appBar(),
      body: Column(
        children: [
          _searchBar(),
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: controller.showFilters.value
                  ? _filters()
                  : const SizedBox(),
            ),
          ),
          _addButton(),
          Expanded(child: _productsList()),
        ],
      ),
      bottomNavigationBar: bottomNav(),
    );
  }

  /* ================= APP BAR ================= */

  PreferredSizeWidget _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: const Text(
        'Produits',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {},
            ),
            Positioned(
              right: 10,
              top: 10,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.red,
                child: const Text(
                  '4',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /* ================= SEARCH BAR ================= */

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (v) => controller.search.value = v,
              decoration: InputDecoration(
                hintText: 'Rechercher un produit...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => controller.showFilters.toggle(),
          ),
        ],
      ),
    );
  }

  /* ================= FILTRES AVANCÉS (COMME LA MAQUETTE) ================= */

  Widget _filters() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filtres avancés',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              GestureDetector(
                onTap: controller.resetFilters,
                child: Text(
                  'Réinitialiser',
                  style: TextStyle(color: primary, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Ligne 1 : Statut et Catégorie
          Row(
            children: [
              Expanded(
                child: _dropdown('Statut', [
                  'Tous',
                  'Disponible',
                  'Indisponible',
                ], controller.statusFilter),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _dropdown('Catégorie', [
                  'Toutes',
                  'Bière',
                  'Cocktail',
                  'Vin',
                  'Soft',
                  'Promotion',
                ], controller.categoryFilter),
              ),
            ],
          ),

          // Ligne 2 : Date d'ajout et Gamme de prix
          Row(
            children: [
              Expanded(
                child: _dropdown('Date d\'ajout', [
                  'Toutes',
                  'Aujourd\'hui',
                  'Cette semaine',
                  'Ce mois',
                  'Plus ancien',
                ], controller.dateFilter),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _dropdown('Gamme de prix', [
                  'Tous',
                  'Moins de 1000',
                  '1000 - 5000',
                  'Plus de 5000',
                ], controller.priceRangeFilter),
              ),
            ],
          ),

          // Ligne 3 : Niveau de stock (pleine largeur)
          _dropdown('Niveau de stock', [
            'Tous',
            'Faible (< 10)',
            'Moyen (10-50)',
            'Élevé (> 50)',
          ], controller.stockLevelFilter),
        ],
      ),
    );
  }

  Widget _dropdown(String label, List<String> items, RxString value) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField<String>(
          value: value.value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => value.value = v!,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontSize: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }

  /* ================= BOUTON AJOUTER ================= */

  Widget _addButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: () => showAddProductBottomSheet(Get.context!),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Ajouter un produit',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  /* ================= LISTE DES PRODUITS ================= */

  Widget _productsList() {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.filteredProducts.length,
        itemBuilder: (_, i) {
          final p = controller.filteredProducts[i];
          return TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 400),
            tween: Tween(begin: 0, end: 1),
            builder: (_, v, __) => Opacity(
              opacity: v,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - v)),
                child: _productCard(p),
              ),
            ),
          );
        },
      ),
    );
  }

  /* ================= CARTE PRODUIT ================= */

  Widget _productCard(Map<String, dynamic> p) {
    final available = p['status'] == 'available';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              p['image'],
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${p['priceCfa']} CFA',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  'Stock : ${p['stock']}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: [
                    _chip(
                      p['category'],
                      const Color.fromARGB(255, 219, 234, 254),
                      textColor: const Color.fromARGB(255, 37, 99, 235),
                    ),
                    _chip(
                      available ? 'Disponible' : 'Indisponible',
                      available
                          ? const Color.fromARGB(255, 220, 252, 231)
                          : const Color.fromARGB(255, 254, 226, 226),
                      textColor: available
                          ? const Color.fromARGB(255, 22, 163, 74)
                          : const Color.fromARGB(255, 176, 14, 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton(
            color: Colors.white,
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                onTap: () => showEditProductBottomSheet(Get.context!, p),
                child: Row(
                  children: [
                    const Icon(Icons.edit_outlined, size: 16),
                    const SizedBox(width: 8),
                    const Text('Modifier'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => controller.toggleProductStatus(p['id']),
                child: Row(
                  children: [
                    Icon(
                      available
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(available ? 'Désactiver' : 'Activer'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => controller.deleteProduct(p['id']),
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_outline_outlined,
                      size: 16,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Supprimer',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /* ================= CHIP (BADGE) ================= */

  Widget _chip(String text, Color bgColor, {Color textColor = Colors.black}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
