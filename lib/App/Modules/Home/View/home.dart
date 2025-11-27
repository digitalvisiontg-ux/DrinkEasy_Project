import 'package:drink_eazy/Api/models/produit.dart';
import 'package:drink_eazy/Api/provider/cartProvider.dart';
import 'package:drink_eazy/App/Modules/Home/View/appbar.dart';
import 'package:drink_eazy/App/Modules/Home/View/buildProductCard.dart';
import 'package:drink_eazy/App/Modules/Home/View/qr_scanner_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/produit_provider.dart';
import 'dart:ui';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _selectedCategory = 'Tous';
  bool _isSearching = false;

  List<String> _categories(BuildContext context) {
    final source = Provider.of<ProduitProvider>(context).produits;
    final cats = source
        .where((p) => p.categorie != null)
        .map((p) => p.categorie!.nomCat)
        .toSet()
        .toList();

    cats.insert(0, 'Tous');
    cats.insert(1, 'Promotion');
    return cats;
  }

  String _emojiForCategory(String category) {
    switch (category.toLowerCase()) {
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

  List<Produit> _filteredProduits(BuildContext context) {
    final produits = Provider.of<ProduitProvider>(context).produits;
    final query = _searchController.text.trim().toLowerCase();

    return produits.where((p) {
      final matchQuery = query.isEmpty || p.nomProd.toLowerCase().contains(query);

      if (_selectedCategory == 'Promotion') {
        return matchQuery && (p.promotionActive || p.promotionsDetails.isNotEmpty);
      }

      if (_selectedCategory == 'Tous') return matchQuery;

      return matchQuery && p.categorie?.nomCat.trim() == _selectedCategory;
    }).toList();
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 45,
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                style: const TextStyle(fontSize: 14),
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
            child: _isSearching
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      _searchFocusNode.unfocus();
                      setState(() => _isSearching = false);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text('Annuler',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  )
                : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    final cats = _categories(context);
    return SizedBox(
      height: 40,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = cats[i];
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
              await showDialog(context: context, builder: (_) => const QrScannerModal());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0.5,
            ),
            child: const Text('Scanner', style: TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  void _retry() {
    // Rafraîchir la page en forçant setState
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final produits = Provider.of<ProduitProvider>(context).produits;
    final items = _filteredProduits(context);
    final isOffline = produits.isEmpty;

    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Consumer<CartProvider>(
              builder: (_, cart, __) {
                return buildAppBar(cart.totalItems);
              },
            ),
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
  child: RefreshIndicator(
    color: Colors.amber,
    onRefresh: () async {
      await Provider.of<ProduitProvider>(context, listen: false).fetchProduits();
    },
    child: items.isEmpty
        ? ListView(
            // Nécessaire pour que RefreshIndicator fonctionne même si la liste est vide
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Center(
                child: Text(
                  isOffline ? '' : 'Aucun résultat',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ),
            ],
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final p = items[i];
              return buildProductCard(
                context: context,
                produit: p,
                onCartUpdated: () => setState(() {}),
                updateCartCount: (q) => setState(() {}),
              );
            },
          ),
  ),
),
            ],
          ),
          bottomNavigationBar: Material(
            elevation: 6,
            child: SafeArea(top: false, child: _buildBottomScannerBar()),
          ),
        ),

        // --- Pop-up hors connexion ---
        if (isOffline)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
              alignment: Alignment.center,
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.symmetric(horizontal: 32),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off, size: 50, color: Colors.amber),
                      const SizedBox(height: 16),
                      const Text(
                        'Vous êtes hors connexion.\nVeuillez vous connecter et réessayer.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _retry,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        child: const Text('Réessayer', style: TextStyle(color: Colors.black87)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
