import 'package:drink_eazy/Admin_App/Admin_Modules/AdminPromotionsPage/AddPromotionSheet.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/AdminPromotionsPage/EditPromotionSheet.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/Admin_Json/Admin_promotions_Json.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/admin_Appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Admin_BottomNavigationBar/Admin_BottomNavigationBar.dart';

/* =========================================================
   CONTROLLER GETX – PROMOTIONS
   ========================================================= */

class AdminPromotionsController extends GetxController {
  var promotions = <Map<String, dynamic>>[].obs;
  var selectedProducts = <String>[].obs;

  @override
  void onInit() {
    promotions.assignAll(promotionsJson);
    super.onInit();
  }

  void addPromotion(Map<String, dynamic> promo) {
    promotions.add(promo);
    Get.snackbar(
      'Succès',
      'Promotion créée avec succès',
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void togglePromoStatus(String id) {
    final index = promotions.indexWhere((p) => p['id'] == id);
    if (index == -1) return;

    final current = promotions[index]['status'];
    promotions[index]['status'] = current == 'active' ? 'inactive' : 'active';
    promotions.refresh();

    Get.snackbar(
      'Statut modifié',
      current == 'active' ? 'Promotion désactivée' : 'Promotion activée',
      backgroundColor: Colors.blue.shade100,
      colorText: Colors.blue.shade900,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void deletePromotion(String id) {
    promotions.removeWhere((p) => p['id'] == id);
    Get.snackbar(
      'Succès',
      'Promotion supprimée',
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
}

/* =========================================================
   PAGE ADMIN – PROMOTIONS
   ========================================================= */

class AdminPromotionsPage extends StatelessWidget {
  AdminPromotionsPage({super.key});

  final controller = Get.put(AdminPromotionsController());
  final primary = const Color(0xFF2F5BEA);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: appBar(context, "Promotions"),
      body: Column(
        children: [
          _addButton(context, isTablet),
          Expanded(child: _promotionsList(context, isTablet)),
        ],
      ),
      bottomNavigationBar: bottomNav(currentIndex: 2),
    );
  }

  /* ================= APP BAR ================= */

  /* ================= BOUTON AJOUTER ================= */

  Widget _addButton(BuildContext context, bool isTablet) {
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 8),
      child: ElevatedButton.icon(
        onPressed: () => _showAddPromotionSheet(context),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Ajouter promotion',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          minimumSize: const Size.fromHeight(52),
          elevation: 2,
          shadowColor: primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  /* ================= LISTE PROMOTIONS ================= */

  Widget _promotionsList(BuildContext context, bool isTablet) {
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return Obx(() {
      if (controller.promotions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_offer_outlined,
                size: 64,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Aucune promotion',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Créez votre première promotion',
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
        itemCount: controller.promotions.length,
        itemBuilder: (_, i) {
          final promo = controller.promotions[i];
          return TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 300 + (i * 50)),
            tween: Tween(begin: 0, end: 1),
            builder: (_, v, __) => Opacity(
              opacity: v,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - v)),
                child: _promotionCard(promo, isTablet),
              ),
            ),
          );
        },
      );
    });
  }

  /* ================= CARTE PROMOTION ================= */

  Widget _promotionCard(Map<String, dynamic> promo, bool isTablet) {
    final isActive = promo['status'] == 'active';
    final isPercentage = promo['type'] == 'percentage';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        promo['productName'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 16 : 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _statusChip(isActive),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: Colors.blue,
                    ),
                    onPressed: () =>
                        _showEditPromotionSheet(Get.context!, promo),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  SizedBox(width: isTablet ? 8 : 4),
                  IconButton(
                    icon: Icon(
                      isActive
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_outline,
                      size: 18,
                      color: Colors.orange,
                    ),
                    onPressed: () => controller.togglePromoStatus(promo['id']),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  SizedBox(width: isTablet ? 8 : 4),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.red,
                    ),
                    onPressed: () => controller.deletePromotion(promo['id']),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// TYPE DE PROMOTION
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isPercentage
                  ? const Color(0xFFDBEAFE)
                  : const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPercentage ? Icons.percent : Icons.card_giftcard,
                  size: 14,
                  color: isPercentage
                      ? const Color(0xFF2563EB)
                      : const Color(0xFF16A34A),
                ),
                const SizedBox(width: 6),
                Text(
                  isPercentage ? 'Prix réduit' : 'Offre spéciale',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isPercentage
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// DESCRIPTION
          Text(
            promo['description'],
            style: const TextStyle(fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),

          /// DATES
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: Colors.grey,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Du ${_formatDate(promo['startDate'])} au ${_formatDate(promo['endDate'])}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusChip(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? const Color.fromARGB(255, 220, 252, 231)
            : const Color.fromARGB(255, 229, 231, 235),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isActive
              ? const Color.fromARGB(255, 22, 163, 74)
              : const Color.fromARGB(255, 107, 114, 128),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /* ================= BOTTOM SHEET AJOUTER ================= */

  void _showAddPromotionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddPromotionSheet(),
    );
  }

  void _showEditPromotionSheet(
    BuildContext context,
    Map<String, dynamic> promo,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditPromotionSheet(promo: promo),
    );
  }
}


