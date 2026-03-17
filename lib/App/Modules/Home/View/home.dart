import 'package:drink_eazy/Api/models/produit.dart';
import 'package:drink_eazy/Api/provider/running_order_provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:drink_eazy/App/Modules/Home/View/appbar.dart';
import 'package:drink_eazy/App/Modules/Home/View/buildProductCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/produit_provider.dart';
import 'package:drink_eazy/Api/provider/cartProvider.dart';
import 'dart:async';
import 'dart:ui';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _selectedCategory = 'Tous';
  bool _isSearching = false;
  final ScrollController _listController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  Timer? _autoRefreshTimer;
  bool _isRefreshing = false;
  static const Duration _autoInterval = Duration(seconds: 30);
  static const Duration _refreshTimeout = Duration(seconds: 12);
  bool _errorDialogOpen = false;

  late RunningOrderProvider _runningOrderProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _runningOrderProvider = Provider.of<RunningOrderProvider>(
      context,
      listen: false,
    );

    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (auth.isAuthenticated) {
      _runningOrderProvider.startUserOrdersPolling();
    } else {
      _runningOrderProvider.stopUserOrdersPolling();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final ro = Provider.of<RunningOrderProvider>(context, listen: false);
      // Vérification initiale et démarrage du polling si connecté
      if (auth.isAuthenticated) {
        ro.startUserOrdersPolling();
      } else {
        ro.stopUserOrdersPolling();
      }
      _startAutoRefresh();
      final pp = Provider.of<ProduitProvider>(context, listen: false);
      if (pp.error != null) {
        _showErrorPopup(pp.error!);
      }
    });
  }

  void _startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer =
        Timer.periodic(_autoInterval, (_) => _triggerAutoRefresh());
  }

  Future<void> _triggerAutoRefresh() async {
    if (_isRefreshing) return;
    if (!mounted) return;
    _refreshKey.currentState?.show();
  }

  Future<void> _onRefresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    final oldOffset = _listController.hasClients ? _listController.offset : 0.0;
    final provider = context.read<ProduitProvider>();
    Future<void> task;
    if (_selectedCategory == 'Tous') {
      task = provider.fetchProduits();
    } else if (_selectedCategory == 'Promotion') {
      task = provider.fetchProduitsEnPromotion();
    } else {
      task = provider.fetchProduitsParCategorie(_selectedCategory);
    }
    bool finished = false;
    await Future.any([
      task.then((_) => finished = true),
      Future.delayed(_refreshTimeout),
    ]);
    if (!finished) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Temps d'actualisation dépassé"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      final err = provider.error;
      if (err != null && mounted) {
        _showErrorPopup(err);
      }
    }
    if (mounted && _listController.hasClients) {
      _listController.jumpTo(oldOffset);
    }
    _isRefreshing = false;
  }

  void _showErrorPopup(String message) {
    if (_errorDialogOpen) return;
    _errorDialogOpen = true;
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Erreur',
      barrierColor: Colors.black.withOpacity(0.2),
      pageBuilder: (ctx, a1, a2) {
        final size = MediaQuery.of(ctx).size;
        return Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(color: Colors.transparent),
              ),
            ),
            Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: size.width * 0.84,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off, color: Colors.redAccent, size: 36),
                      const SizedBox(height: 10),
                      const Text(
                        "Problème de connexion",
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            Navigator.of(ctx).pop();
                            _errorDialogOpen = false;
                            await _onRefresh();
                          },
                          child: const Text(
                            "Réessayer",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (ctx, anim, _, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: child,
        );
      },
    ).then((_) {
      _errorDialogOpen = false;
    });
  }

  // ------------------------------
  // FILTRAGE PRODUITS
  // ------------------------------
  List<Produit> get _filteredProducts {
    final provider = Provider.of<ProduitProvider>(context);
    final produits = provider.produits;
    final query = _searchController.text.trim().toLowerCase();

    return produits.where((p) {
      final matchQuery =
          query.isEmpty || p.nomProd.toLowerCase().contains(query);

      if (_selectedCategory == 'Promotion') {
        return matchQuery &&
            (p.promotionActive || p.promotionsDetails.isNotEmpty);
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
                    borderSide: const BorderSide(
                      color: Colors.amber,
                      width: 1.8,
                    ),
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
          ),
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

  List<String> _categories(BuildContext context) {
    final provider = Provider.of<ProduitProvider>(context);
    final produits = provider.produits;

    final setCats = <String>{};
    for (final p in produits) {
      final name = p.categorie?.nomCat.trim();
      if (name != null && name.isNotEmpty) setCats.add(name);
    }

    final List<String> result = ['Tous', 'Promotion'];
    result.addAll(
      setCats.where(
        (c) => c.toLowerCase() != 'promotion' && c.toLowerCase() != 'tous',
      ),
    );
    return result;
  }

  // 🔥 BOTTOM FLOTTANT AVEC RUNNING ORDER PROVIDER
  Widget _buildRunningOrderBottomCard() {
    final ro = Provider.of<RunningOrderProvider>(context);
    final cmd = ro.currentBannerOrder;
    if (!ro.shouldShowBanner || cmd == null) return const SizedBox.shrink();

    final media = MediaQuery.of(context);
    final double horizontalPadding = media.size.width * 0.04;
    final double iconSize = media.size.width < 360 ? 20 : 22;
    final double iconBoxSize = media.size.width < 360 ? 36 : 40;

    return Positioned(
      right: horizontalPadding,
      bottom: media.padding.bottom + 12,
      child: SafeArea(
        top: false,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          builder: (context, value, child) => Opacity(opacity: value, child: child!),
          child: Align(
            alignment: Alignment.centerRight,
            widthFactor: 1,
            heightFactor: 1,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Get.toNamed("/MesCommandesPage");
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Container(
                    width: iconBoxSize,
                    height: iconBoxSize,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      maxWidth: 44,
                      minHeight: 32,
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  // Widget _buildRunningOrderBottomCard() {
  //   final ro = Provider.of<RunningOrderProvider>(context);
  //   final cmd = ro.currentBannerOrder;
  //   if (!ro.shouldShowBanner || cmd == null) return const SizedBox.shrink();

  //   final media = MediaQuery.of(context);
  //   final double horizontalPadding = media.size.width * 0.04;
  //   final double iconSize = media.size.width < 360 ? 20 : 22;

  //   return Positioned(
  //     left: horizontalPadding,
  //     right: horizontalPadding,
  //     bottom: media.padding.bottom + 12,
  //     child: SafeArea(
  //       top: false,
  //       child: TweenAnimationBuilder<double>(
  //         tween: Tween(begin: 0, end: 1),
  //         duration: const Duration(milliseconds: 250),
  //         curve: Curves.easeOut,
  //         builder: (context, value, child) => Opacity(opacity: value, child: child!),
  //         child: Material(
  //           elevation: 5,
  //           borderRadius: BorderRadius.circular(18),
  //           child: InkWell(
  //             borderRadius: BorderRadius.circular(18),
  //             onTap: () {
  //               Get.toNamed("/MesCommandesPage");
  //             },
  //             child: Container(
  //               padding: EdgeInsets.symmetric(
  //                 horizontal: media.size.width * 0.04,
  //                 vertical: media.size.height * 0.018,
  //               ),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(18),
  //               ),
  //               child: Row(
  //                 children: [
  //                   Container(
  //                     width: media.size.width * 0.11,
  //                     height: media.size.width * 0.11,
  //                     constraints: const BoxConstraints(
  //                       minWidth: 38,
  //                       maxWidth: 44,
  //                       minHeight: 38,
  //                       maxHeight: 44,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: const Color(0xFFC8FFD4),
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: Icon(
  //                       Icons.restaurant_menu,
  //                       color: Colors.green,
  //                       size: iconSize,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 14),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         const Text(
  //                           "Status de votre commande",
  //                           maxLines: 1,
  //                           overflow: TextOverflow.ellipsis,
  //                           style: TextStyle(
  //                             fontWeight: FontWeight.w700,
  //                             fontSize: 14,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 4),
  //                         Text(
  //                           "Table #${cmd.tableLibelle} • ${cmd.numeroCommande}",
  //                           maxLines: 1,
  //                           overflow: TextOverflow.ellipsis,
  //                           style: const TextStyle(
  //                             fontSize: 13,
  //                             color: Colors.black54,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   const SizedBox(width: 10),
  //                   Icon(
  //                     Icons.arrow_forward_ios,
  //                     size: media.size.width < 360 ? 16 : 18,
  //                     color: Colors.black45,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _autoRefreshTimer?.cancel();
    _listController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final ro = Provider.of<RunningOrderProvider>(context, listen: false);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      ro.pauseBannerHideCountdown();
      debugPrint("Home: lifecycle paused -> banner hide timer paused");
    } else if (state == AppLifecycleState.resumed) {
      ro.resumeBannerHideCountdown();
      debugPrint("Home: lifecycle resumed -> banner hide timer resumed");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Écoute dynamique du nombre d'articles global via le CartProvider
    final cartCount = context.watch<CartProvider>().totalItems;
    final items = _filteredProducts;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: buildAppBar(cartCount),
      ),
      backgroundColor: const Color(0xFFF8F8F8),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 12),
              _buildSearchField(),
              const SizedBox(height: 12),
              _buildCategoryChips(),
              const SizedBox(height: 8),
              Expanded(
                child: RefreshIndicator(
                  key: _refreshKey,
                  onRefresh: _onRefresh,
                  child: items.isEmpty
                      ? ListView(
                          controller: _listController,
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: const EdgeInsets.only(top: 8, bottom: 12),
                          children: [
                            Center(
                              child: Text(
                                'Aucun résultat',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          controller: _listController,
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: const EdgeInsets.only(top: 8, bottom: 12),
                          itemBuilder: (context, index) {
                            final p = items[index];
                            return buildProductCard(
                              context: context,
                              produit: p,
                              onCartUpdated: () => setState(() {}),
                              // On ne gère plus le compteur local, le Provider s'occupe de la réactivité
                              updateCartCount: (qty) {},
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemCount: items.length,
                        ),
                ),
              ),
            ],
          ),
          _buildRunningOrderBottomCard(),
        ],
      ),
    );
  }
}
