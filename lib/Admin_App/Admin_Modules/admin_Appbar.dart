import 'package:drink_eazy/Admin_App/Admin_Modules/Admin_NotificationsPages/Admin_NotificationsPages.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/Admin_NotificationsPages/Admin_NotificationsPages.dart'
    show AdminNotificationsController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

PreferredSizeWidget appBar(BuildContext context, String title) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    actions: [
      Builder(
        builder: (_) {
          // Récupérer le contrôleur de notifications (ou le créer s'il n'existe pas encore)
          final controller =
              Get.isRegistered<AdminNotificationsController>()
                  ? Get.find<AdminNotificationsController>()
                  : Get.put(AdminNotificationsController());

          return Obx(
            () => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none,
                      color: Colors.black),
                  onPressed: () {
                    Get.to(() => AdminNotificationsPage());
                  },
                ),
                if (controller.unreadCount > 0)
                  Positioned(
                    right: 10,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        controller.unreadCount.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      const SizedBox(width: 8),
    ],
  );
}
