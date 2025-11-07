import 'package:drink_eazy/Api/models/produit.dart';
import 'package:drink_eazy/App/Modules/Home/View/appbar.dart';
import 'package:drink_eazy/App/Modules/Home/View/buildProductCard.dart';
import 'package:drink_eazy/App/Modules/Home/View/qr_scanner_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/produit_provider.dart';

class Home extends StatefulWidget {
  final List<Produit> produits;
  const Home({super.key, this.produits = const []});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _selectedCategory = 'Tous';
  int cartCount = 0;
  bool _isSearching = false;

  // --- Liste des catégories avec emojis et style
  List<String> _categories(BuildContext context) {
    final source = widget.produits.isNotEmpty
        ? widget.produits
        : Provider.of<ProduitProvider>(context).produits;
    final cats = source.map((p) => p.categorieNom ?? 'Autre').toSet().toList();
    cats.insert(0, 'Tous');
    return cats;
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

  // --- Filtrage des produits
  List<Produit> _filteredProduits(BuildContext context) {
    final source = widget.produits.isNotEmpty
        ? widget.produits
        : Provider.of<ProduitProvider>(context).produits;
    final query = _searchController.text.trim().toLowerCase();

    return source.where((p) {
      final matchesQuery =
          query.isEmpty || p.nomProd.toLowerCase().contains(query);
      final matchesCategory =
          _selectedCategory == 'Tous' || (p.categorieNom?.trim() == _selectedCategory);
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filteredProduits(context);

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
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final p = items[index];
                      return buildProduitCard(
                        context: context,
                        produit: p,
                        onCartUpdated: () => setState(() {}),
                        updateCartCount: (qty) => setState(() => cartCount += qty),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Material(
        elevation: 6,
        child: SafeArea(top: false, child: _buildBottomScannerBar()),
      ),
    );
  }

  // --- Champ de recherche
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 45,
              child: TextField(
                style: const TextStyle(fontSize: 14),
                controller: _searchController,
                focusNode: _searchFocusNode,
                onTap: () => setState(() => _isSearching = true),
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
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
            child: _isSearching
                ? Padding(
                    key: const ValueKey('cancel'),
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        _searchFocusNode.unfocus();
                        setState(() => _isSearching = false);
                      },
                      child: const Text(
                        'Annuler',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),
        ],
      ),
    );
  }

  // --- Chips de catégories avec emojis
  Widget _buildCategoryChips() {
    final cats = _categories(context);
    return SizedBox(
      height: 40,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = cats[index];
          final selected = _selectedCategory == cat;
          return ChoiceChip(
            showCheckmark: false,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_emojiForCategory(cat), style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Text(cat, style: const TextStyle(color: Colors.black, fontSize: 15)),
              ],
            ),
            selected: selected,
            selectedColor: Colors.amber,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: selected ? Colors.amber : Colors.grey.shade300, width: 1.2),
            ),
            onSelected: (_) => setState(() => _selectedCategory = cat),
          );
        },
      ),
    );
  }

  // --- Barre du bas pour scanner le QR code
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
          )),
          ElevatedButton(
            onPressed: () async {
              await showDialog(context: context, builder: (_) => const QrScannerModal());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('Scanner', style: TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
