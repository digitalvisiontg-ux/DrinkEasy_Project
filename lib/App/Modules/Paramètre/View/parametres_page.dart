import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParametresPage extends StatefulWidget {
  const ParametresPage({super.key});

  @override
  State<ParametresPage> createState() => _ParametresPageState();
}

class _ParametresPageState extends State<ParametresPage> {
  bool notificationsEnabled = true;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Paramètres",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          const SizedBox(height: 12),
          _buildSectionTitle("Compte"),
          _buildSettingTile(
            icon: Icons.person_outline,
            title: "Mon profil",
            subtitle: "Voir et modifier vos informations personnelles",
            onTap: () => Get.snackbar("Profil", "Ouverture du profil..."),
          ),
          _buildSettingTile(
            icon: Icons.lock_outline,
            title: "Changer le mot de passe",
            subtitle: "Modifier votre mot de passe de connexion",
            onTap: () =>
                Get.snackbar("Sécurité", "Changement du mot de passe..."),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle("Préférences"),
          _buildSwitchTile(
            icon: Icons.notifications_none,
            title: "Notifications",
            subtitle: "Recevoir des alertes et offres spéciales",
            value: notificationsEnabled,
            onChanged: (val) {
              setState(() => notificationsEnabled = val);
            },
          ),
          _buildSwitchTile(
            icon: Icons.dark_mode_outlined,
            title: "Mode sombre",
            subtitle: "Changer le thème de l'application",
            value: darkMode,
            onChanged: (val) {
              setState(() => darkMode = val);
              Get.snackbar(
                "Thème",
                val ? "Mode sombre activé 🌙" : "Mode clair activé ☀️",
              );
            },
          ),
          const SizedBox(height: 24),
          _buildSectionTitle("Support"),
          _buildSettingTile(
            icon: Icons.help_outline,
            title: "Centre d’aide",
            subtitle: "Consultez la FAQ ou contactez le support",
            onTap: () => Get.snackbar("Support", "Redirection vers l’aide..."),
          ),
          _buildSettingTile(
            icon: Icons.privacy_tip_outlined,
            title: "Confidentialité",
            subtitle: "Politique de confidentialité et sécurité",
            onTap: () =>
                Get.snackbar("Confidentialité", "Ouverture de la politique..."),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle("Application"),
          _buildSettingTile(
            icon: Icons.info_outline,
            title: "À propos",
            subtitle: "Version 1.0.0 — Drink Eazy ©2025",
          ),
          const SizedBox(height: 28),
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Get.defaultDialog(
                  title: "Déconnexion",
                  middleText: "Voulez-vous vraiment vous déconnecter ?",
                  textConfirm: "Oui",
                  textCancel: "Annuler",
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    Get.back(); // fermer le dialogue
                    Get.offAllNamed("/connexion"); // rediriger vers connexion
                  },
                );
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                "Déconnexion",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w700,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.orange.shade700),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.black26,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.orange.shade700),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        trailing: Switch(
          value: value,
          activeColor: Colors.orange.shade700,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
