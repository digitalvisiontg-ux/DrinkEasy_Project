import 'package:drink_eazy/Admin_App/Admin_Modules/admin_Appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Admin_BottomNavigationBar/Admin_BottomNavigationBar.dart';

/* =========================================================
   CONTROLLER GETX – STATISTIQUES
   ========================================================= */

class AdminStatisticsController extends GetxController {
  // Stats du jour
  var todayOrders = 24.obs;
  var todayRevenue = 200000.obs;

  // Stats de la semaine
  var weekRevenue = 1000000.obs;
  var weekDays = 7.obs;

  // Stock bas
  var lowStockCount = 3.obs;

  // Top produits
  final topProducts = <Map<String, dynamic>>[
    {'rank': 1, 'name': 'Bière Blonde', 'revenue': 1000000, 'soldCount': 45},
    {'rank': 2, 'name': 'Café Expresso', 'revenue': 500000, 'soldCount': 38},
    {'rank': 3, 'name': 'Club Sandwich', 'revenue': 200000, 'soldCount': 22},
    {'rank': 4, 'name': 'Coca-Cola', 'revenue': 100000, 'soldCount': 31},
  ].obs;

  // Alertes stock
  final stockAlerts = <Map<String, dynamic>>[
    {'product': 'Club Sandwich', 'status': 'rupture', 'stock': 0},
    {'product': 'Jus d\'Orange', 'status': 'low', 'stock': 2},
    {'product': 'Salade César', 'status': 'low', 'stock': 3},
  ].obs;
}

/* =========================================================
   PAGE ADMIN – STATISTIQUES
   ========================================================= */

class AdminStatisticsPage extends StatelessWidget {
  AdminStatisticsPage({super.key});

  final controller = Get.put(AdminStatisticsController());
  final primary = const Color(0xFF2F5BEA);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: appBar(context, "Statistiques"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// CARTES STATISTIQUES
            _statsCards(isTablet),
            const SizedBox(height: 24),

            /// PRODUITS LES PLUS VENDUS
            _topProducts(isTablet),
            const SizedBox(height: 24),

            /// ALERTES STOCK BAS
            _stockAlerts(isTablet),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: bottomNav(currentIndex: 3),
    );
  }

  /* ================= CARTES STATISTIQUES ================= */

  Widget _statsCards(bool isTablet) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Obx(
                () => _statCard(
                  icon: Icons.receipt_long,
                  iconColor: const Color(0xFF2563EB),
                  bgColor: const Color(0xFFDBEAFE),
                  title: 'Commandes',
                  value: controller.todayOrders.value.toString(),
                  subtitle: 'Aujourd\'hui',
                  isTablet: isTablet,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(
                () => _statCard(
                  icon: Icons.attach_money,
                  iconColor: const Color(0xFF16A34A),
                  bgColor: const Color(0xFFDCFCE7),
                  title: 'Revenus',
                  value:
                      '${controller.todayRevenue.value.toStringAsFixed(0)} CFA', 
                  subtitle: 'Aujourd\'hui',
                  isTablet: isTablet,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        /// LIGNE 2 : Semaine + Stock bas
        Row(
          children: [
            Expanded(
              child: Obx(
                () => _statCard(
                  icon: Icons.trending_up,
                  iconColor: const Color(0xFF9333EA),
                  bgColor: const Color(0xFFF3E8FF),
                  title: 'Semaine',
                  value: '${controller.weekRevenue.value.toStringAsFixed(0)} CFA',
                  subtitle: '${controller.weekDays.value} derniers jours',
                  isTablet: isTablet,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(
                () => _statCard(
                  icon: Icons.warning_amber_rounded,
                  iconColor: const Color(0xFFEA580C),
                  bgColor: const Color(0xFFFFEDD5),
                  title: 'Stock bas',
                  value: controller.lowStockCount.value.toString(),
                  subtitle: 'Produits',
                  isTablet: isTablet,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String value,
    required String subtitle,
    required bool isTablet,
  }) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bgColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: iconColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 18 : 15,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  /* ================= PRODUITS LES PLUS VENDUS ================= */

  Widget _topProducts(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events_outlined,
                color: Colors.amber,
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'Produits les plus vendus',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// LISTE DES TOP PRODUITS
          Obx(
            () => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.topProducts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final product = controller.topProducts[i];
                return _topProductItem(product, isTablet);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _topProductItem(Map<String, dynamic> product, bool isTablet) {
    return Row(
      children: [
        /// RANG
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: _getRankColor(product['rank']),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              product['rank'].toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        /// NOM
        Expanded(
          child: Text(
            product['name'],
            style: TextStyle(
              fontSize: isTablet ? 15 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        /// REVENUS + VENDUS
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${product['revenue'].toStringAsFixed(0)} CFA',
              style: TextStyle(
                fontSize: isTablet ? 15 : 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF16A34A),
              ),
            ),
            Text(
              '${product['soldCount']} vendus',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFF2563EB);
      case 2:
        return const Color(0xFF2563EB);
      case 3:
        return const Color(0xFF2563EB);
      case 4:
        return const Color(0xFF2563EB);
      default:
        return Colors.grey;
    }
  }

  /* ================= ALERTES STOCK BAS ================= */

  Widget _stockAlerts(bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFECACA), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xFFDC2626),
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'Alertes stock bas',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC2626),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// LISTE DES ALERTES
          Obx(
            () => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.stockAlerts.length,
              separatorBuilder: (_, __) => Divider(
                height: 24,
                color: const Color(0xFFFECACA).withOpacity(0.5),
              ),
              itemBuilder: (_, i) {
                final alert = controller.stockAlerts[i];
                return _stockAlertItem(alert, isTablet);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _stockAlertItem(Map<String, dynamic> alert, bool isTablet) {
    final isRupture = alert['status'] == 'rupture';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            alert['product'],
            style: TextStyle(
              fontSize: isTablet ? 15 : 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isRupture
                ? const Color(0xFFDC2626)
                : Colors.orange,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            isRupture
                ? 'Stock épuisé'
                : '${alert['stock']} restant${alert['stock'] > 1 ? 's' : ''}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
