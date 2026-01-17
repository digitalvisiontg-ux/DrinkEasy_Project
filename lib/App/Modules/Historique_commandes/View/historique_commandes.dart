import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoriqueCommandesPage extends StatefulWidget {
  const HistoriqueCommandesPage({super.key});

  @override
  State<HistoriqueCommandesPage> createState() =>
      _HistoriqueCommandesPageState();
}

class _HistoriqueCommandesPageState extends State<HistoriqueCommandesPage> {
  String selectedFilter = "Toutes";

  final List<Map<String, dynamic>> allOrders = [
    {
      "orderId": "#6021",
      "table": 4,
      "date": DateTime.now(),
      "total": 4500,
      "status": "Servie",
      "items": 5,
    },
    {
      "orderId": "#6015",
      "table": 2,
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "total": 3200,
      "status": "Servie",
      "items": 3,
    },
    {
      "orderId": "#6008",
      "table": 6,
      "date": DateTime.now().subtract(const Duration(days: 6)),
      "total": 6100,
      "status": "Annulée",
      "items": 6,
    },
  ];

  List<Map<String, dynamic>> get filteredOrders {
    final now = DateTime.now();

    if (selectedFilter == "Aujourd’hui") {
      return allOrders.where((order) {
        final date = order["date"] as DateTime;
        return date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
      }).toList();
    }

    if (selectedFilter == "Cette semaine") {
      return allOrders.where((order) {
        final date = order["date"] as DateTime;
        return now.difference(date).inDays <= 7;
      }).toList();
    }

    return allOrders;
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
          "Historique des commandes",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: filteredOrders.isEmpty
                ? _emptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      return _orderCard(filteredOrders[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 🔘 FILTRES
  // --------------------------------------------------
  Widget _buildFilters() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(6),
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
      child: Row(
        children: [
          _filterChip("Toutes"),
          _filterChip("Aujourd’hui"),
          _filterChip("Cette semaine"),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final bool isSelected = selectedFilter == label;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedFilter = label);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.amber : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: isSelected ? Colors.black : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 🧾 CARD COMMANDE
  // --------------------------------------------------
  Widget _orderCard(Map<String, dynamic> order) {
    final bool isCancelled = order["status"] == "Annulée";
    final DateTime date = order["date"];

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
            "Commande ${order["orderId"]}",
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
                      color: isCancelled
                          ? Colors.red.withOpacity(0.12)
                          : Colors.green.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.receipt_long,
                      color: isCancelled
                          ? Colors.red.shade700
                          : Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Commande ${order["orderId"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${date.day}/${date.month}/${date.year}",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _statusChip(order["status"]),
                ],
              ),

              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoItem(
                    icon: Icons.restaurant_menu,
                    label: "Table",
                    value: "#${order["table"]}",
                  ),
                  _infoItem(
                    icon: Icons.shopping_bag_outlined,
                    label: "Articles",
                    value: "${order["items"]}",
                  ),
                  _infoItem(
                    icon: Icons.payments_outlined,
                    label: "Total",
                    value: "${order["total"]} CFA",
                    isBold: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    final Color bg = status == "Servie"
        ? const Color(0xFFD8FFE5)
        : Colors.red.withOpacity(0.12);
    final Color text = status == "Servie"
        ? const Color(0xFF2AA55B)
        : Colors.red.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: text,
        ),
      ),
    );
  }

  Widget _infoItem({
    required IconData icon,
    required String label,
    required String value,
    bool isBold = false,
  }) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _emptyState() {
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
          const Text(
            "Aucune commande",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
