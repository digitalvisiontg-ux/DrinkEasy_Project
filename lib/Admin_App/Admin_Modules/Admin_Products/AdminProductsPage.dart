import 'package:drink_eazy/Admin_App/Admin_Modules/Admin_BottomNavigationBar/Admin_BottomNavigationBar.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/Admin_Json/Admin_Product_Json.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/Admin_Products/AddProductBottomSheet.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/Admin_Products/EditProductBottomSheet.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/admin_Appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminProductsController extends GetxController {
  var products = <Map<String, dynamic>>[].obs;
  var search = ''.obs;
  var showFilters = false.obs;

  // Filtres
  var statusFilter = 'Tous'.obs;
  var categoryFilter = 'Toutes'.obs;
  var dateFilter = 'Toutes'.obs;
  var priceRangeFilter = 'Tous'.obs;
  var stockLevelFilter = 'Tous'.obs;

  @override
  void onInit() {
    products.assignAll(productsJson);
    super.onInit();
  }

  // Getter pour le nombre de produits filtrés
  int get filteredCount => filteredProducts.length;

  List<Map<String, dynamic>> get filteredProducts {
    return products.where((p) {
      final matchSearch = p['name'].toLowerCase().contains(
        search.value.toLowerCase(),
      );

      final matchStatus =
          statusFilter.value == 'Tous' ||
          (statusFilter.value == 'Disponible' && p['status'] == 'available') ||
          (statusFilter.value == 'Indisponible' &&
              p['status'] == 'unavailable');

      final matchCategory =
          categoryFilter.value == 'Toutes' ||
          p['category'] == categoryFilter.value;

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
    Get.snackbar(
      'Succès',
      'Produit supprimé',
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void toggleProductStatus(String id) {
    final index = products.indexWhere((p) => p['id'] == id);
    if (index == -1) return;

    final current = products[index]['status'];
    final newStatus = current == 'available' ? 'unavailable' : 'available';
    products[index]['status'] = newStatus;
    products.refresh();

    Get.snackbar(
      'Statut modifié',
      newStatus == 'available' ? 'Produit activé' : 'Produit désactivé',
      backgroundColor: Colors.blue.shade100,
      colorText: Colors.blue.shade900,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void addProduct(Map<String, dynamic> product) {
    products.add(product);
    Get.snackbar(
      'Succès',
      'Produit ajouté avec succès',
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void updateProduct(String id, Map<String, dynamic> updates) {
    final index = products.indexWhere((p) => p['id'] == id);
    if (index == -1) return;

    products[index].addAll(updates);
    products.refresh();

    Get.snackbar(
      'Succès',
      'Produit modifié avec succès',
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
}

class AdminProductsPage extends StatelessWidget {
  AdminProductsPage({super.key});

  final controller = Get.put(AdminProductsController());
  final primary = const Color(0xFF2F5BEA);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: appBar(context, "Produits"),
      body: Column(
        children: [
          _searchBar(context),
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: controller.showFilters.value
                  ? _filters(context, isTablet)
                  : const SizedBox.shrink(),
            ),
          ),
          _productCount(),
          _addButton(context),
          Expanded(child: _productsList(context, isTablet)),
        ],
      ),
      bottomNavigationBar: bottomNav(currentIndex: 0),
    );
  }

  /* ================= SEARCH BAR - RESPONSIVE ================= */

  Widget _searchBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width > 600 ? 24.0 : 16.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (v) => controller.search.value = v,
              decoration: InputDecoration(
                hintText: 'Rechercher un produit...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13, ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: primary, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Obx(
            () => Container(
              decoration: BoxDecoration(
                color: controller.showFilters.value ? primary : Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: controller.showFilters.value
                    ? [
                        BoxShadow(
                          color: primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.tune,
                  color: controller.showFilters.value
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () => controller.showFilters.toggle(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* ================= COMPTEUR PRODUITS ================= */

  Widget _productCount() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${controller.filteredCount} produit${controller.filteredCount > 1 ? 's' : ''}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* ================= FILTRES - RESPONSIVE ================= */

  Widget _filters(BuildContext context, bool isTablet) {
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Réinitialiser',
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isTablet)
            // Layout tablette : 3 colonnes
            Column(
              children: [
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dropdown('Date d\'ajout', [
                        'Toutes',
                        'Aujourd\'hui',
                        'Cette semaine',
                        'Ce mois',
                        'Plus ancien',
                      ], controller.dateFilter),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _dropdown('Gamme de prix', [
                        'Tous',
                        'Moins de 1000',
                        '1000 - 5000',
                        'Plus de 5000',
                      ], controller.priceRangeFilter),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dropdown('Niveau de stock', [
                        'Tous',
                        'Faible (< 10)',
                        'Moyen (10-50)',
                        'Élevé (> 50)',
                      ], controller.stockLevelFilter),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ],
            )
          else
            // Layout mobile : 2 colonnes
            Column(
              children: [
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
                _dropdown('Niveau de stock', [
                  'Tous',
                  'Faible (< 10)',
                  'Moyen (10-50)',
                  'Élevé (> 50)',
                ], controller.stockLevelFilter),
              ],
            ),
        ],
      ),
    );
  }

  Widget _dropdown(String label, List<String> items, RxString value) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField<String>(
          
          borderRadius: BorderRadius.circular(12),
          isDense: true,
          isExpanded: true,
          value: value.value,
          items: items
              .map((e) => DropdownMenuItem(value: e, 
              child: Text(e, style: TextStyle(fontSize: 15, ),)))
              .toList(),
          onChanged: (v) => value.value = v!,
          decoration: InputDecoration(

            labelText: label,
            labelStyle: const TextStyle(fontSize: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primary, width: 1.5),
            ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10, // réduit pour éviter les overflow verticaux
          ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  /* ================= BOUTON AJOUTER - RESPONSIVE ================= */

  Widget _addButton(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width > 600 ? 24.0 : 16.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
      child: ElevatedButton.icon(
        onPressed: () => showAddProductBottomSheet(context),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Ajouter un produit',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          minimumSize: const Size.fromHeight(52),
          elevation: 2,
          shadowColor: primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  /* ================= LISTE PRODUITS - RESPONSIVE ================= */

  Widget _productsList(BuildContext context, bool isTablet) {
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return Obx(() {
      if (controller.filteredProducts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Aucun produit trouvé',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Essayez de modifier vos filtres',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          8,
          horizontalPadding,
          16,
        ),
        itemCount: controller.filteredProducts.length,
        itemBuilder: (_, i) {
          final p = controller.filteredProducts[i];
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (i * 50)),
            tween: Tween(begin: 0, end: 1),
            builder: (_, v, __) => Opacity(
              opacity: v,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - v)),
                child: _productCard(p, isTablet),
              ),
            ),
          );
        },
      );
    });
  }

  /* ================= CARTE PRODUIT - RESPONSIVE ================= */

  Widget _productCard(Map<String, dynamic> p, bool isTablet) {
    final available = p['status'] == 'available';
    final imageSize = isTablet ? 80.0 : 60.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              p['image'],
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: imageSize,
                height: imageSize,
                color: Colors.grey[200],
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(width: isTablet ? 16 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 16 : 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${p['priceCfa']} CFA',
                  style: TextStyle(
                    fontSize: isTablet ? 15 : 14,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Stock : ${p['stock']}',
                  style: TextStyle(
                    fontSize: 13,
                    color: p['stock'] < 10 ? Colors.orange : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            icon: Icon(Icons.more_vert, color: Colors.grey[700]),
            itemBuilder: (_) => [
              PopupMenuItem(
                onTap: () => Future.delayed(
                  const Duration(milliseconds: 100),
                  () => showEditProductBottomSheet(Get.context!, p),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 18, color: Colors.blue),
                    SizedBox(width: 12),
                    Text('Modifier'),
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
                      size: 18,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 12),
                    Text(available ? 'Désactiver' : 'Activer'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () => controller.deleteProduct(p['id']),
                child: const Row(
                  children: [
                    Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Supprimer', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /* ================= CHIP ================= */

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
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
