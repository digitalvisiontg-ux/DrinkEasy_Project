import 'package:drink_eazy/Api/models/produit.dart';
import 'package:drink_eazy/Api/provider/cartProvider.dart';
import 'package:drink_eazy/App/Modules/Home/View/appbar.dart';
import 'package:drink_eazy/App/Modules/Home/View/buildProductCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/produit_provider.dart';
import 'dart:ui';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _selectedCategory = 'Tous';
  int cartCount = 0;
  bool _isSearching = false;

  Map<String, dynamic>? runningOrder;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null && args is Map<String, dynamic>) {
      setState(() {
        runningOrder = args;
      });
    }
  }

  // ------------------------------
  // FILTRAGE PRODUITS
  // ------------------------------
  List<Product> get _filteredProducts {
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

  // --- Barre de recherche ---
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
                onTap: () => setState(() => _isSearching = true),
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
              ),
            ),
          ),

          // --- Bouton Annuler ---
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
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
                : const SizedBox.shrink(),
          )
        ],
      ),
    );
  }

  // --- Catégories avec emoji ---
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

  String _emojiForCategory(String cat) {
    switch (cat.toLowerCase().trim()) {
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

  // 🔥 BOTTOM FLOTTANT EXACTEMENT COMME LA MAQUETTE
  // 🔥 BOTTOM FLOTTANT EXACTEMENT COMME LA MAQUETTE
  Widget _buildRunningOrderBottomCard() {
    if (runningOrder == null) return const SizedBox.shrink();

    final media = MediaQuery.of(context);
    final double horizontalPadding = media.size.width * 0.04; // adaptatif
    final double iconSize = media.size.width < 360 ? 20 : 22;

    return Positioned(
      left: horizontalPadding,
      right: horizontalPadding,
      bottom: media.padding.bottom * 0.2 + 0,
      child: SafeArea(
        top: false,
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              Get.toNamed("/orderDetails", arguments: runningOrder);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: media.size.width * 0.04,
                vertical: media.size.height * 0.018,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  // ICON
                  Container(
                    width: media.size.width * 0.11,
                    height: media.size.width * 0.11,
                    constraints: const BoxConstraints(
                      minWidth: 38,
                      maxWidth: 44,
                      minHeight: 38,
                      maxHeight: 44,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC8FFD4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.restaurant_menu,
                      color: Colors.green,
                      size: iconSize,
                    ),
                  ),

                  const SizedBox(width: 14),

                  // TEXTE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Commande en cours",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Table #${runningOrder!["tableNumber"]} • ${runningOrder!["orderId"]}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // CHEVRON
                  Icon(
                    Icons.arrow_forward_ios,
                    size: media.size.width < 360 ? 16 : 18,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------
  // CONTENU PRINCIPAL
  // ------------------------------
  Widget _buildContent() {
    final items = _filteredProducts;

    return Column(
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
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 8, bottom: 50),
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
        SizedBox(
          height: runningOrder == null
              ? 25
              : MediaQuery.of(context).padding.bottom + 40,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: buildAppBar(cartCount),
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: Stack(children: [_buildContent(), _buildRunningOrderBottomCard()]),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}

// ------------------------------
// CLASS PRODUCT
// ------------------------------
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
