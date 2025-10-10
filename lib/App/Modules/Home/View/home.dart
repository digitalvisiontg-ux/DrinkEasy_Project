// main.dart
import 'package:drink_eazy/App/Component/text_component.dart';
import 'package:drink_eazy/App/Modules/Home/View/productDetailModal.dart';
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
  int _cartCount = 0;

  final List<String> categories = [
    'Tous',
    'Bière',
    'Cocktail',
    'Vin',
    'Soft',
    'Spiritueux',
  ];

  final List<Product> _products = [
    Product(
      name: 'Heineken',
      category: 'Bière',
      priceCfa: 1500,
      imagepath: 'assets/images/boisson9.jpg',
    ),
    Product(
      name: 'Castel',
      category: 'Bière',
      priceCfa: 1200,
      imagepath: 'assets/images/boisson2.jpg',
    ),
    Product(
      name: 'Strawberry Daiquiri',
      category: 'Cocktail',
      priceCfa: 800,
      imagepath: 'assets/images/cocktail2.jpg',
    ),
    Product(
      name: 'Mojito',
      category: 'Soft',
      priceCfa: 2500,
      imagepath: 'assets/images/boisson3.jpg',
    ),
    Product(
      name: 'Piña Colada',
      category: 'Vin',
      priceCfa: 3000,
      imagepath: 'assets/images/boisson4.jpg',
    ),
    Product(
      name: 'Chardonnay',
      category: 'Vin',
      priceCfa: 4000,
      imagepath: 'assets/images/boisson5.jpg',
    ),
    Product(
      name: 'Gin Tonic',
      category: 'Spiritueux',
      priceCfa: 2800,
      imagepath: 'assets/images/boisson6.jpg',
    ),

    Product(
      name: 'Gin Tonic',
      category: 'Cocktail',
      priceCfa: 1200,
      imagepath: 'assets/images/cocktail3.jpg',
    ),
  ];

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      titleSpacing: 0,
      title: Row(
        children: [
          const SizedBox(width: 8),
          Text(
            'DrinkEasy',
            style: TextStyle(
              color: Colors.red.shade800,
              fontSize: 26,
              fontFamily: "Agbalumo",
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.black87),
          onPressed: () {},
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black87,
              ),
              onPressed: () {},
            ),
            if (_cartCount > 0)
              Positioned(
                right: 0,
                top: -3,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '$_cartCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  List<Product> get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();
    return _products.where((p) {
      final matchesQuery =
          query.isEmpty || p.name.toLowerCase().contains(query);
      final matchesCategory =
          _selectedCategory == 'Tous' || p.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  void _addToCart(Product p) {
    setState(() {
      _cartCount += 1;
    });
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${p.name} ajouté au panier'),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
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
            borderSide: BorderSide(color: Colors.amber, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(color: Colors.amber, width: 2),
          ),
        ),
        textInputAction: TextInputAction.search,
      ),
    );
  }

  // ignore: unused_element
  Widget _buildCategoryChip() {
    return SizedBox(
      child: ListView.separated(
        // ignore: body_might_complete_normally_nullable
        itemBuilder: (context, index) {
          final cat = categories[index];
          // ignore: unused_local_variable
          final selected = _selectedCategory == cat;
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: categories.length,
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final selected = _selectedCategory == cat;
          return ChoiceChip(
            showCheckmark: false,
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _chipEmojiFor(cat),
                SizedBox(width: 4),
                Text(cat, style: TextStyle(color: Colors.black)),
              ],
            ),
            selected: selected,
            selectedColor: Colors.amber,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
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

  Widget _chipEmojiFor(String cat) {
    switch (cat) {
      case 'Bière':
        return const Text('🍺', style: TextStyle(fontSize: 16));
      case 'Cocktail':
        return const Text('🍸', style: TextStyle(fontSize: 16));
      case 'Vin':
        return const Text('🍷', style: TextStyle(fontSize: 16));
      case 'Soft':
        return const Text('🧃', style: TextStyle(fontSize: 16));
      case 'Spiritueux':
        return const Text('🥃', style: TextStyle(fontSize: 16));
      default:
        return const Text('🍽️', style: TextStyle(fontSize: 16));
    }
  }

  Widget _buildProductCard(Product p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 36,
                // ignore: deprecated_member_use
                backgroundColor: Colors.grey.withOpacity(0.1),
                backgroundImage: AssetImage(p.imagepath ?? ''),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        p.category,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const Spacer(),
                      TextComponent(text: "${_formatPrice(p.priceCfa)} CFA"),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () async {
                    final qty = await showDialog<int>(
                      context: context,
                      builder: (_) => ProductDetailModal(product: p),
                    );

                    if (qty != null && qty > 0) {
                      setState(() {
                        _cartCount += qty;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${p.name} x$qty ajouté au panier'),
                          duration: const Duration(milliseconds: 900),
                        ),
                      );
                    }
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.amber,
                    radius: 22,
                    child: Icon(Icons.add, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    // Simple formatting: group thousands with space
    final s = price.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write(' ');
        count = 0;
      }
    }
    return buffer.toString().split('').reversed.join('');
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
              await showDialog(
                context: context,
                builder: (_) => const QrScannerModal(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 2,
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

  @override
  Widget build(BuildContext context) {
    final items = _filteredProducts;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: _buildAppBar(),
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
                    padding: const EdgeInsets.only(top: 8, bottom: 12),
                    itemBuilder: (context, index) {
                      final p = items[index];
                      return _buildProductCard(p);
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: items.length,
                  ),
          ),
          Material(elevation: 6, child: _buildBottomScannerBar()),
        ],
      ),
    );
  }
}

class Product {
  final String name;
  final String category;
  final int priceCfa;
  final String? imagepath;

  Product({
    required this.name,
    required this.category,
    required this.priceCfa,
    required this.imagepath,
  });
}
