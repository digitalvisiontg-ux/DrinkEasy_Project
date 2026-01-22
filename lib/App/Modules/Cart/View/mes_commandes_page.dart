import 'dart:async';
import 'package:drink_eazy/Api/models/commande_model.dart';
import 'package:drink_eazy/Api/models/commande_produit_model.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:drink_eazy/Api/services/commande_service.dart';
import 'package:drink_eazy/App/Modules/Cart/View/CommandeValideePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class MesCommandesPage extends StatefulWidget {
  const MesCommandesPage({super.key});

  @override
  State<MesCommandesPage> createState() => _MesCommandesPageState();
}

class _MesCommandesPageState extends State<MesCommandesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CommandeService _commandeService = CommandeService();
  List<CommandeModel> _orders = [];
  bool _isLoading = true;
  Timer? _pollTimer;
  bool _isRefreshing = false;
  static const Duration _pollInterval = Duration(seconds: 30);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchOrders();
    _startPolling();
  }

  Future<String> getGuestToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('guest_token');
    if (token == null) {
      token = const Uuid().v4();
      await prefs.setString('guest_token', token);
    }
    return token;
  }

  Future<void> _fetchOrders() async {
    try {
      final auth = context.read<AuthProvider>();

      List<Map<String, dynamic>> rawOrders;
      if (auth.isAuthenticated) {
        rawOrders = await _commandeService.getUserCommandes();
      } else {
        final guestToken = await getGuestToken();
        rawOrders = await _commandeService.getGuestCommandes(guestToken);
      }

      if (!mounted) return;
      setState(() {
        _orders = rawOrders.map((e) => CommandeModel.fromJson(e)).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Erreur récupération commandes: $e");
      if (!mounted) return;
      setState(() {
        _orders = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshOrdersSilently() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    try {
      final auth = context.read<AuthProvider>();
      List<Map<String, dynamic>> rawOrders;
      if (auth.isAuthenticated) {
        rawOrders = await _commandeService.getUserCommandes();
      } else {
        final guestToken = await getGuestToken();
        rawOrders = await _commandeService.getGuestCommandes(guestToken);
      }
      if (!mounted) return;
      setState(() {
        _orders = rawOrders.map((e) => CommandeModel.fromJson(e)).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      });
    } catch (_) {} finally {
      _isRefreshing = false;
    }
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(_pollInterval, (_) => _refreshOrdersSilently());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pollTimer?.cancel();
    super.dispose();
  }

  List<CommandeModel> _filter(String category) {
    return _orders.where((o) {
      final s = o.status.toLowerCase().trim();
      switch (category) {
        case "en_cours":
          return [
            'in_progress',
            'pending',
            'en_cours',
            'en_attente',
            'confirmed',
            'started',
            'ready',
            'validée',
            'validee',
          ].contains(s);
        case "terminee":
          return [
            'completed',
            'paid',
            'servi',
            'terminee',
            'livrée',
            'livree',
            'delivered',
            'served',
          ].contains(s);
        case "annulee":
          return [
            'cancelled',
            'annulee',
            'refusee',
            'rejetée',
            'rejetee',
            'rejected',
          ].contains(s);
        default:
          return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.4,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Mes commandes",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              await _fetchOrders();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 0,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(width: 3, color: Colors.amber),
                ),
                dividerColor: Colors.transparent,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                splashFactory: NoSplash.splashFactory,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 0.3,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                tabs: const [
                  Tab(text: "En cours"),
                  Tab(text: "Terminées"),
                  Tab(text: "Annulées"),
                ],
              ),
            ),
          ),
        ),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : RefreshIndicator(
              onRefresh: _fetchOrders,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildList(
                    _filter("en_cours"),
                    emptyText: "Aucune commande en cours",
                  ),
                  _buildList(
                    _filter("terminee"),
                    emptyText: "Aucune commande terminée",
                  ),
                  _buildList(
                    _filter("annulee"),
                    emptyText: "Aucune commande annulée",
                  ),
                ],
              ),
            ),
    );
  }

  // --------------------------------------------------
  // 🧾 LISTE DES COMMANDES
  // --------------------------------------------------
  Widget _buildList(List<CommandeModel> data, {required String emptyText}) {
    if (data.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [_emptyState(emptyText)],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _orderCard(data[index]);
      },
    );
  }

  // --------------------------------------------------
  // 📦 CARD COMMANDE
  // --------------------------------------------------
  Widget _orderCard(CommandeModel order) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (order.status) {
      case 'in_progress':
        statusColor = Colors.orange;
        statusText = 'En cours';
        statusIcon = Icons.timelapse;
        break;

      case 'completed':
      case 'paid':
        statusColor = Colors.green;
        statusText = order.status == 'paid' ? 'Payée' : 'Terminée';
        statusIcon = Icons.check_circle_outline;
        break;

      case 'cancelled':
        statusColor = Colors.red;
        statusText = 'Annulée';
        statusIcon = Icons.cancel_outlined;
        break;

      default:
        statusColor = Colors.grey;
        statusText = order.status;
        statusIcon = Icons.help_outline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          // Navigation vers la page de détails (réutilisation de CommandeValideePage)
          // On adapte les données pour qu'elles correspondent à ce que attend la page
          final itemsSnapshot = order.produits
              .map(
                (e) => {'product': ProduitAdapter(e), 'quantity': e.quantite},
              )
              .toList();

          Get.to(
            () => CommandeValideePage(
              cartItems: itemsSnapshot,
              totalPrice: order.total.toInt(),
              tableNumber: order.tableLibelle,
              commande: order,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(statusIcon, color: statusColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Commande ${order.numeroCommande}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Table ${order.tableLibelle}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat(
                            'dd/MM/yyyy HH:mm',
                          ).format(order.createdAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _statusChip(statusText, statusColor),
                ],
              ),

              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _info(
                    "Articles",
                    "${order.produits.length}",
                    Icons.shopping_bag_outlined,
                  ),
                  _info(
                    "Total",
                    "${order.total.toInt()} CFA",
                    Icons.payments_outlined,
                    bold: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _info(String label, String value, IconData icon, {bool bold = false}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _emptyState(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            "Vos commandes apparaîtront ici",
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class ProduitAdapter {
  final CommandeProduit _cp;
  ProduitAdapter(this._cp);
  String get nomProd => _cp.nomProduit;
  double get prixFinal => _cp.prixUnitaire;
}
