import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MesCommandesPage extends StatefulWidget {
  const MesCommandesPage({super.key});

  @override
  State<MesCommandesPage> createState() => _MesCommandesPageState();
}

class _MesCommandesPageState extends State<MesCommandesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> orders = [
    {
      "id": "#7012",
      "table": 3,
      "total": 5200,
      "items": 4,
      "status": "en_cours",
      "date": DateTime.now(),
    },
    {
      "id": "#7009",
      "table": 1,
      "total": 3100,
      "items": 2,
      "status": "terminee",
      "date": DateTime.now().subtract(const Duration(hours: 3)),
    },
    {
      "id": "#7001",
      "table": 6,
      "total": 6400,
      "items": 6,
      "status": "annulee",
      "date": DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _filter(String status) {
    return orders.where((o) => o["status"] == status).toList();
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

      body: TabBarView(
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
          _buildList(_filter("annulee"), emptyText: "Aucune commande annulée"),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 🧾 LISTE DES COMMANDES
  // --------------------------------------------------
  Widget _buildList(
    List<Map<String, dynamic>> data, {
    required String emptyText,
  }) {
    if (data.isEmpty) {
      return _emptyState(emptyText);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _orderCard(data[index]);
      },
    );
  }

  // --------------------------------------------------
  // 📦 CARD COMMANDE
  // --------------------------------------------------
  Widget _orderCard(Map<String, dynamic> order) {
    final status = order["status"];

    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case "en_cours":
        statusColor = Colors.orange;
        statusText = "En cours";
        statusIcon = Icons.timelapse;
        break;
      case "terminee":
        statusColor = Colors.green;
        statusText = "Terminée";
        statusIcon = Icons.check_circle_outline;
        break;
      default:
        statusColor = Colors.red;
        statusText = "Annulée";
        statusIcon = Icons.cancel_outlined;
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
          Get.snackbar(
            "Commande ${order["id"]}",
            "Ouverture des détails...",
            snackPosition: SnackPosition.BOTTOM,
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
                          "Commande ${order["id"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Table ${order["table"]}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
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
                    "${order["items"]}",
                    Icons.shopping_bag_outlined,
                  ),
                  _info(
                    "Total",
                    "${order["total"]} CFA",
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
