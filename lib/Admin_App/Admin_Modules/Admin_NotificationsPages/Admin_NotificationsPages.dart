import 'package:drink_eazy/Admin_App/Admin_Modules/Admin_Json/Admin_notifications_Json.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


/* =========================================================
   CONTROLLER GETX – NOTIFICATIONS
   ========================================================= */

class AdminNotificationsController extends GetxController {
  var notifications = <Map<String, dynamic>>[].obs;
  var selectedFilter = 'all'.obs; // all, order, stock, promotion, system
  var showOnlyUnread = false.obs;

  @override
  void onInit() {
    notifications.assignAll(notificationsJson);
    super.onInit();
  }

  int get unreadCount => notifications.where((n) => !n['isRead']).length;

  List<Map<String, dynamic>> get filteredNotifications {
    var filtered = notifications.where((n) {
      // Filtre par type
      final matchType =
          selectedFilter.value == 'all' || n['type'] == selectedFilter.value;

      // Filtre par statut lu/non-lu
      final matchRead = !showOnlyUnread.value || !n['isRead'];

      return matchType && matchRead;
    }).toList();

    // Trier par date (plus récent en premier)
    filtered.sort(
      (a, b) => (b['time'] as DateTime).compareTo(a['time'] as DateTime),
    );

    return filtered;
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n['id'] == id);
    if (index != -1) {
      notifications[index]['isRead'] = true;
      notifications.refresh();
    }
  }

  void markAllAsRead() {
    for (var notif in notifications) {
      notif['isRead'] = true;
    }
    notifications.refresh();

    Get.snackbar(
      'Succès',
      'Toutes les notifications ont été marquées comme lues',
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void deleteNotification(String id) {
    notifications.removeWhere((n) => n['id'] == id);

    Get.snackbar(
      'Supprimée',
      'Notification supprimée',
      backgroundColor: Colors.grey.shade100,
      colorText: Colors.grey.shade900,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void clearAll() {
    notifications.clear();

    Get.snackbar(
      'Succès',
      'Toutes les notifications ont été supprimées',
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }
}

/* =========================================================
   PAGE ADMIN – NOTIFICATIONS
   ========================================================= */

class AdminNotificationsPage extends StatelessWidget {
  AdminNotificationsPage({super.key});

  final controller = Get.put(AdminNotificationsController());
  final primary = const Color(0xFF2F5BEA);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: _appBar(context),
      body: Column(
        children: [
          _header(isTablet),
          _filters(isTablet),
          Expanded(child: _notificationsList(context, isTablet)),
        ],
      ),
    );
  }

  /* ================= APP BAR ================= */

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        'Notifications',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          itemBuilder: (_) => [
            PopupMenuItem(
              onTap: controller.markAllAsRead,
              child: const Row(
                children: [
                  Icon(Icons.done_all, size: 18, color: Colors.blue),
                  SizedBox(width: 12),
                  Text('Tout marquer comme lu'),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () => _confirmClearAll(context),
              child: const Row(
                children: [
                  Icon(Icons.delete_sweep, size: 18, color: Colors.red),
                  SizedBox(width: 12),
                  Text('Tout supprimer', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  /* ================= HEADER ================= */

  Widget _header(bool isTablet) {
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return Obx(
      () => Container(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          16,
          horizontalPadding,
          12,
        ),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${controller.filteredNotifications.length} notification${controller.filteredNotifications.length > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (controller.unreadCount > 0)
                  Text(
                    '${controller.unreadCount} non lue${controller.unreadCount > 1 ? 's' : ''}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Non lues',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: controller.showOnlyUnread.value,
                  onChanged: (v) => controller.showOnlyUnread.value = v,
                  activeColor: primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /* ================= FILTRES ================= */

  Widget _filters(bool isTablet) {
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 12,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _filterChip('Toutes', 'all'),
              const SizedBox(width: 8),
              _filterChip('Commandes', 'order'),
              const SizedBox(width: 8),
              _filterChip('Stock', 'stock'),
              const SizedBox(width: 8),
              _filterChip('Promotions', 'promotion'),
              const SizedBox(width: 8),
              _filterChip('Système', 'system'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final isSelected = controller.selectedFilter.value == value;

    return GestureDetector(
      onTap: () => controller.selectedFilter.value = value,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primary : const Color(0xFFE0E0E0),
            width: isSelected ? 0 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  /* ================= LISTE NOTIFICATIONS ================= */

  Widget _notificationsList(BuildContext context, bool isTablet) {
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return Obx(() {
      if (controller.filteredNotifications.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notifications_none, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                'Aucune notification',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                controller.showOnlyUnread.value
                    ? 'Toutes vos notifications sont lues'
                    : 'Vous n\'avez pas encore de notifications',
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
        itemCount: controller.filteredNotifications.length,
        itemBuilder: (_, i) {
          final notif = controller.filteredNotifications[i];
          return _notificationCard(notif, isTablet);
        },
      );
    });
  }

  /* ================= CARTE NOTIFICATION ================= */

  Widget _notificationCard(Map<String, dynamic> notif, bool isTablet) {
    final isRead = notif['isRead'];
    final type = notif['type'];
    final priority = notif['priority'];

    return Dismissible(
      key: Key(notif['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => controller.deleteNotification(notif['id']),
      child: GestureDetector(
        onTap: () {
          if (!isRead) {
            controller.markAsRead(notif['id']);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(isTablet ? 16 : 14),
          decoration: BoxDecoration(
            color: isRead ? Colors.white : primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isRead
                  ? const Color(0xFFE0E0E0)
                  : primary.withOpacity(0.2),
              width: isRead ? 1 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ICÔNE TYPE
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getTypeColor(type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTypeIcon(type),
                  color: _getTypeColor(type),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),

              /// CONTENU
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notif['title'],
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (priority == 'high')
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.priority_high,
                              size: 12,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notif['message'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(notif['time']),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        if (!isRead) ...[
                          const SizedBox(width: 12),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Nouveau',
                            style: TextStyle(
                              fontSize: 12,
                              color: primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* ================= HELPERS ================= */

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'order':
        return Icons.receipt_long;
      case 'stock':
        return Icons.inventory_2;
      case 'promotion':
        return Icons.local_offer;
      case 'system':
        return Icons.settings;
      default:
        return Icons.notifications;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'order':
        return const Color(0xFF2563EB);
      case 'stock':
        return const Color(0xFFEA580C);
      case 'promotion':
        return const Color(0xFF16A34A);
      case 'system':
        return const Color(0xFF9333EA);
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'À l\'instant';
    } else if (diff.inMinutes < 60) {
      return 'Il y a ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'Il y a ${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return 'Il y a ${diff.inDays}j';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  void _confirmClearAll(BuildContext context) {
    Get.defaultDialog(
      title: 'Confirmation',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText:
          'Êtes-vous sûr de vouloir supprimer toutes les notifications ?',
      textConfirm: 'Supprimer',
      textCancel: 'Annuler',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.grey[700],
      onConfirm: () {
        controller.clearAll();
        Get.back();
      },
      radius: 12,
    );
  }
}
