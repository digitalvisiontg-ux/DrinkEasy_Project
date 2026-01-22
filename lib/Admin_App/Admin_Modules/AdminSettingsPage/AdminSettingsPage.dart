import 'package:drink_eazy/Admin_App/Admin_Modules/AdminSettingsPage/AddStaffSheet.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/AdminSettingsPage/ChangePasswordSheet.dart';
import 'package:drink_eazy/Admin_App/Admin_Modules/admin_Appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Admin_BottomNavigationBar/Admin_BottomNavigationBar.dart';

/* =========================================================
   JSON PERSONNEL
   ========================================================= */

final List<Map<String, dynamic>> staffJson = [
  {
    'id': 'staff1',
    'name': 'Marie Martin',
    'email': 'marie@bar.com',
    'role': 'Serveur',
    'status': 'active',
    'initials': 'MM',
  },
  {
    'id': 'staff2',
    'name': 'Pierre Durand',
    'email': 'pierre@bar.com',
    'role': 'Barman',
    'status': 'active',
    'initials': 'PD',
  },
  {
    'id': 'staff3',
    'name': 'Sophie Leroy',
    'email': 'sophie@bar.com',
    'role': 'Serveur',
    'status': 'inactive',
    'initials': 'SL',
  },
];

/* =========================================================
   CONTROLLER GETX – PARAMÈTRES
   ========================================================= */

class AdminSettingsController extends GetxController {
  var currentTab = 0.obs;
  var staff = <Map<String, dynamic>>[].obs;

  // Profil admin
  var adminName = 'Jean Dupont'.obs;
  var adminEmail = 'jean.dupont@email.com'.obs;
  var adminPhone = '+33 6 12 34 56 78'.obs;

  @override
  void onInit() {
    staff.assignAll(staffJson);
    super.onInit();
  }

  void updateProfile(String name, String email, String phone) {
    adminName.value = name;
    adminEmail.value = email;
    adminPhone.value = phone;

    Get.snackbar(
      'Succès',
      'Profil mis à jour avec succès',
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void addStaff(Map<String, dynamic> member) {
    staff.add(member);
    Get.snackbar(
      'Succès',
      'Membre ajouté avec succès',
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void toggleStaffStatus(String id) {
    final index = staff.indexWhere((s) => s['id'] == id);
    if (index != -1) {
      final current = staff[index]['status'];
      staff[index]['status'] = current == 'active' ? 'inactive' : 'active';
      staff.refresh();
    }
  }

  void deleteStaff(String id) {
    staff.removeWhere((s) => s['id'] == id);
    Get.snackbar(
      'Succès',
      'Membre supprimé',
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  int get activeStaffCount =>
      staff.where((s) => s['status'] == 'active').length;
}

/* =========================================================
   PAGE ADMIN – PARAMÈTRES
   ========================================================= */

class AdminSettingsPage extends StatelessWidget {
  AdminSettingsPage({super.key});

  final controller = Get.put(AdminSettingsController());
  final primary = const Color(0xFF2F5BEA);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: appBar(context, "Paramètres"),
      body: Column(
        children: [
          _tabs(isTablet),
          Expanded(
            child: Obx(
              () => controller.currentTab.value == 0
                  ? _profilTab(context, isTablet)
                  : _personnelTab(context, isTablet),
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNav(currentIndex: 4),
    );
  }
  /* ================= TABS ================= */

  Widget _tabs(bool isTablet) {
    return Obx(
      () => Container(
        margin: EdgeInsets.fromLTRB(
          isTablet ? 24 : 16,
          16,
          isTablet ? 24 : 16,
          16,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F8FB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(child: _tabButton('Profil', 0)),
            Expanded(child: _tabButton('Personnel', 1)),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final isActive = controller.currentTab.value == index;
    return GestureDetector(
      onTap: () => controller.currentTab.value = index,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isActive ? primary : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  /* ================= ONGLET PROFIL ================= */

  Widget _profilTab(BuildContext context, bool isTablet) {
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
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
                      Icons.person_outline,
                      color: Color(0xFF2F5BEA),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Profil administrateur',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// AVATAR
                Center(
                  child: Stack(
                    children: [
                      Obx(
                        () => CircleAvatar(
                          radius: 50,
                          backgroundColor: primary,
                          child: Text(
                            _getInitials(controller.adminName.value),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            // Logique pour changer la photo
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Changer la photo',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// NOM COMPLET
                const Text(
                  'Nom complet',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Obx(() => _profilField(controller.adminName.value)),

                const SizedBox(height: 16),

                /// EMAIL
                const Text(
                  'Email',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Obx(() => _profilField(controller.adminEmail.value)),

                const SizedBox(height: 16),

                /// TÉLÉPHONE
                const Text(
                  'Téléphone',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Obx(() => _profilField(controller.adminPhone.value)),

                const SizedBox(height: 20),

                /// CHANGER MOT DE PASSE
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showChangePasswordSheet(context),
                    icon: const Icon(Icons.lock_outline, size: 18),
                    label: const Text('Changer le mot de passe'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: BorderSide(color: Colors.grey[300]!),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// SAUVEGARDER
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Logique pour sauvegarder
                      controller.updateProfile(
                        controller.adminName.value,
                        controller.adminEmail.value,
                        controller.adminPhone.value,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      minimumSize: const Size.fromHeight(52),
                      elevation: 2,
                      shadowColor: primary.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Sauvegarder les modifications',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _profilField(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(value, style: const TextStyle(fontSize: 15)),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'A';
  }

  /* ================= ONGLET PERSONNEL ================= */

  Widget _personnelTab(BuildContext context, bool isTablet) {
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return Column(
      children: [
        /// HEADER
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gestion du personnel',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      '${controller.activeStaffCount} membres actifs',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddStaffSheet(context),
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: const Text(
                  'Ajouter',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  elevation: 2,
                  shadowColor: primary.withOpacity(0.3),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        /// LISTE PERSONNEL
        Expanded(
          child: Obx(
            () => ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              itemCount: controller.staff.length,
              itemBuilder: (_, i) {
                final member = controller.staff[i];
                return _staffCard(member, isTablet);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _staffCard(Map<String, dynamic> member, bool isTablet) {
    final isActive = member['status'] == 'active';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          /// AVATAR
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey[200],
            child: Text(
              member['initials'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 12),

          /// INFOS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  member['email'],
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _roleChip(member['role']),
                    const SizedBox(width: 8),
                    _statusChip(isActive),
                  ],
                ),
              ],
            ),
          ),

          /// ACTIONS
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isActive
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
                  color: Colors.orange,
                  size: 20,
                ),
                onPressed: () => controller.toggleStaffStatus(member['id']),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 20,
                ),
                onPressed: () => _confirmDelete(member['id'], member['name']),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roleChip(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDBEAFE),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        role,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2563EB),
        ),
      ),
    );
  }

  Widget _statusChip(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? const Color.fromARGB(255, 220, 252, 231)
            : const Color.fromARGB(255, 254, 226, 226),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isActive ? 'Actif' : 'Inactif',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isActive
              ? const Color.fromARGB(255, 22, 163, 74)
              : const Color.fromARGB(255, 176, 14, 14),
        ),
      ),
    );
  }

  void _confirmDelete(String id, String name) {
    Get.defaultDialog(
      title: 'Confirmation',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleText: 'Êtes-vous sûr de vouloir supprimer $name ?',
      textConfirm: 'Supprimer',
      textCancel: 'Annuler',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.grey[700],
      onConfirm: () {
        controller.deleteStaff(id);
        Get.back();
      },
      radius: 12,
    );
  }

  /* ================= BOTTOM SHEETS ================= */

  void _showChangePasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangePasswordSheet(),
    );
  }

  void _showAddStaffSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddStaffSheet(),
    );
  }
}


