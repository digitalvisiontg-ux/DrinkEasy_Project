import 'package:drink_eazy/App/Modules/Home/Controller/productController.dart';
import 'package:drink_eazy/App/Modules/Home/View/appbar.dart';
import 'package:drink_eazy/App/Modules/Home/View/buildProductCard.dart';
import 'package:drink_eazy/App/Modules/Home/View/qr_scanner_modal.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Tous';
  int cartCount = 0;

  // --- Filtrage des produits ---
  List<Product> get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();
    return products.where((p) {
      final matchesQuery =
          query.isEmpty || p.name.toLowerCase().contains(query);
      final matchesCategory =
          _selectedCategory == 'Tous' || p.category.trim() == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  // --- Barre de recherche ---
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0),
      child: SizedBox(
        height: 45,
        child: TextField(
          style: const TextStyle(fontSize: 14),
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Rechercher une boisson...',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: const BorderSide(color: Colors.amber, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: const BorderSide(color: Colors.amber, width: 1.8),
            ),
          ),
          textInputAction: TextInputAction.search,
        ),
      ),
    );
  }

  // --- Catégories avec emoji ---
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index].trim();
          final selected = _selectedCategory == cat;

          return ChoiceChip(
            showCheckmark: false,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _emojiForCategory(cat),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 6),
                Text(
                  cat,
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                ),
              ],
            ),
            selected: selected,
            selectedColor: Colors.amber,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(
                color: selected ? Colors.amber : Colors.grey.shade300,
                width: 1.2,
              ),
            ),
            onSelected: (_) {
              setState(() {
                _selectedCategory = cat;
              });
            },
          );
        },
      ),
    );
  }

  String _emojiForCategory(String category) {
    switch (category.toLowerCase().trim()) {
      case 'promotion':
        return '🎉';
      case 'bière':
        return '🍺';
      case 'cocktail':
        return '🍸';
      case 'vin':
        return '🍷';
      case 'soft':
        return '🥤';
      case 'spiritueux':
        return '🥃';
      case 'tous':
        return '🍾';
      default:
        return '🍹';
    }
  }

  // --- Barre du bas ---
  Widget _buildBottomScannerBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Scannez le QR code de votre table pour commander',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (_) => const QrScannerModal(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0.5,
            ),
            child: const Text(
              'Scanner',
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- Interface principale ---
  @override
  Widget build(BuildContext context) {
    final items = _filteredProducts;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: buildAppBar(cartCount),
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildSearchField(),
          const SizedBox(height: 12),
          _buildCategoryChips(),
          const SizedBox(height: 8),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      'Aucun résultat',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 8, bottom: 12),
                    itemBuilder: (context, index) {
                      final p = items[index];
                      return buildProductCard(
                        context: context,
                        p: p,
                        onCartUpdated: () => setState(() {}),
                        updateCartCount: (qty) =>
                            setState(() => cartCount += qty),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemCount: items.length,
                  ),
          ),
          Material(elevation: 6, child: _buildBottomScannerBar()),
        ],
      ),
    );
  }
}

// --- Classe Produit ---
class Product {
  final String name;
  final String category;
  final int priceCfa;
  final String? promotion;
  final int? oldPriceCfa;
  final String? imagepath;
  final String? boissonType;

  Product({
    required this.name,
    required this.category,
    required this.priceCfa,
    required this.boissonType,
    this.oldPriceCfa,
    this.promotion,
    required this.imagepath,
  });
}
