import 'package:drink_eazy/Admin_App/Admin_Modules/AdminOrdersPage.dart/Controller/OrdersController.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/admin_Appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Admin_BottomNavigationBar/Admin_BottomNavigationBar.dart';

/* =========================================================
   PAGE ADMIN – COMMANDES RESPONSIVE
   ========================================================= */

class AdminOrdersPage extends StatelessWidget {
  AdminOrdersPage({super.key});

  final controller = Get.put(AdminOrdersController());
  final primary = const Color(0xFF2F5BEA);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: appBar(context, "Commandes"),
      body: Column(
        children: [
          _searchBar(context),
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: controller.showFilters.value
                  ? _filters(context, isTablet)
                  : const SizedBox.shrink(),
            ),
          ),
          _count(),
          Expanded(child: _ordersList(context, isTablet)),
        ],
      ),
      bottomNavigationBar: bottomNav(currentIndex: 1),
    );
  }

  /* ================= SEARCH BAR ================= */

  Widget _searchBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width > 600 ? 24.0 : 16.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (v) => controller.search.value = v,
              decoration: InputDecoration(
                hintText: 'Rechercher par nom, commande...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13, ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: primary, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Obx(
            () => Container(
              decoration: BoxDecoration(
                color: controller.showFilters.value ? primary : Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: controller.showFilters.value
                    ? [
                        BoxShadow(
                          color: primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.tune,
                  color: controller.showFilters.value
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () => controller.showFilters.toggle(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* ================= FILTRES AVANCÉS ================= */

  Widget _filters(BuildContext context, bool isTablet) {
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filtres avancés',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              GestureDetector(
                onTap: controller.resetFilters,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Réinitialiser',
                    style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isTablet)
            // Layout tablette
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _dropdown('Statut', [
                        'Tous',
                        'En attente',
                        'Confirmée',
                        'Refusée',
                      ], controller.statusFilter),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dropdown('Table', [
                        'Toutes',
                        'Table 1',
                        'Table 2',
                        'Table 3',
                        'Table 4',
                        'Table 5',
                        'Table 6',
                        'Table 7',
                        'Table 8',
                      ], controller.tableFilter),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dropdown('Date', [
                        'Toutes',
                        'Aujourd\'hui',
                        'Cette semaine',
                        'Ce mois',
                      ], controller.dateFilter),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _dropdown('Montant', [
                        'Tous',
                        'Moins de 5000',
                        '5000 - 10000',
                        'Plus de 10000',
                      ], controller.amountFilter),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(child: SizedBox()),
                    const SizedBox(width: 12),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ],
            )
          else
            // Layout mobile
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _dropdown('Statut', [
                        'Tous',
                        'En attente',
                        'Confirmée',
                        'Refusée',
                      ], controller.statusFilter),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dropdown('Table', [
                        'Toutes',
                        'Table 1',
                        'Table 2',
                        'Table 3',
                        'Table 4',
                        'Table 5',
                        'Table 6',
                        'Table 7',
                        'Table 8',
                      ], controller.tableFilter),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _dropdown('Date', [
                        'Toutes',
                        'Aujourd\'hui',
                        'Cette semaine',
                        'Ce mois',
                      ], controller.dateFilter),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dropdown('Montant', [
                        'Tous',
                        'Moins de 5000',
                        '5000 - 10000',
                        'Plus de 10000',
                      ], controller.amountFilter),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _dropdown(String label, List<String> items, RxString value) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField<String>(
          borderRadius: BorderRadius.circular(12),
          isDense: true,
          isExpanded: true,
          value: value.value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: 15, ),)))
              .toList(),
          onChanged: (v) => value.value = v!,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontSize: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  /* ================= COMPTEUR ================= */

  Widget _count() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${controller.filteredCount} commande${controller.filteredCount > 1 ? 's' : ''}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  /* ================= LISTE COMMANDES ================= */

  Widget _ordersList(BuildContext context, bool isTablet) {
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return Obx(() {
      if (controller.filteredOrders.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 64,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Aucune commande trouvée',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Essayez de modifier vos filtres',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          8,
          horizontalPadding,
          16,
        ),
        itemCount: controller.filteredOrders.length,
        itemBuilder: (_, i) {
          final o = controller.filteredOrders[i];
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (i * 50)),
            tween: Tween(begin: 0, end: 1),
            builder: (_, v, __) => Opacity(
              opacity: v,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - v)),
                child: _orderCard(o, isTablet),
              ),
            ),
          );
        },
      );
    });
  }

  /* ================= CARTE COMMANDE ================= */

  Widget _orderCard(Map<String, dynamic> o, bool isTablet) {
    final isPending = o['status'] == 'pending';
    final items = o['items'] as List<dynamic>;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    o['id'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 16 : 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _statusChip(o['status']),
                ],
              ),
              Text(
                '${o['amount']} CFA',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isTablet ? 18 : 16,
                  color: primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// CLIENT & TABLE
          Row(
            children: [
              const Icon(Icons.person_outline, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                o['customer'],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.table_restaurant_outlined,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(o['table']),
            ],
          ),

          const SizedBox(height: 6),

          /// HEURE
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                o['time'],
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),

          const Divider(height: 24),

          /// ARTICLES
          const Text(
            'Articles :',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item['quantity']}x ${item['name']}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  Text(
                    '${item['price'] * item['quantity']} CFA',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isPending) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.confirmOrder(o['id']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      elevation: 2,
                      shadowColor: primary.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(48),
                    ),
                    icon: const Icon(
                      Icons.check_circle_outline,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Confirmer',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.refuseOrder(o['id']),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size.fromHeight(48),
                    ),
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: const Text(
                      'Refuser',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /* ================= CHIP STATUT ================= */

  Widget _statusChip(String status) {
    late Color bg;
    late Color txt;
    late String label;

    switch (status) {
      case 'confirmed':
        bg = const Color.fromARGB(255, 220, 252, 231);
        txt = const Color.fromARGB(255, 22, 163, 74);
        label = 'Confirmée';
        break;
      case 'refused':
        bg = const Color.fromARGB(255, 254, 226, 226);
        txt = const Color.fromARGB(255, 176, 14, 14);
        label = 'Refusée';
        break;
      default:
        bg = const Color.fromARGB(255, 254, 243, 199);
        txt = const Color.fromARGB(255, 217, 119, 6);
        label = 'En attente';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: txt),
      ),
    );
  }
}
