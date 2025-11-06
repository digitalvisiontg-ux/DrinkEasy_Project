import 'package:drink_eazy/App/Component/confirm_component.dart';
import 'package:drink_eazy/App/Component/error_popup_component.dart'
    show showErrorPopupComponent;
import 'package:drink_eazy/App/Component/showMessage_component.dart';
import 'package:drink_eazy/App/Modules/Home/View/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';

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
          Builder(
            builder: (context) {
              final user = Provider.of<AuthProvider>(context).user;
              if (user != null) {
                return _buildSettingTile(
                  icon: Icons.person_outline,
                  title: user['name']?.toString() ?? 'Utilisateur',
                  subtitle:
                      user['email']?.toString() ??
                      user['phone']?.toString() ??
                      'Profil utilisateur',
                  onTap: () => Get.snackbar("Profil", "Ouverture du profil..."),
                );
              } else {
                return _buildSettingTile(
                  icon: Icons.person_outline,
                  title: "Mode invité",
                  subtitle: "Connectez-vous pour gérer votre profil",
                  onTap: () => Get.snackbar(
                    "Profil",
                    "Veuillez vous connecter pour accéder à votre profil",
                  ),
                );
              }
            },
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
          // --- Déconnexion ---
          OutlinedButton.icon(
            onPressed: () async {
              final confirm = await showConfirmComponent(
                context,
                title: 'Déconnexion',
                message: 'Voulez-vous vraiment vous déconnecter ?',
                confirmText: 'Déconnecter',
                cancelText: 'Annuler',
                confirmColor: Colors.red,
                cancelColor: Colors.grey.shade200,
                // icon: Icons.logout_rounded,
                // iconColor: Colors.red,
                // iconBgColor: Colors.redAccent.withOpacity(0.1),
              );

              if (confirm == true) {
                try {
                  final auth = Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  );
                  await auth.logout();
                  Get.offAll(const Home());
                  showMessageComponent(
                    context,
                    'Déconnexion réussie',
                    'Vous avez été déconnecté avec succès.',
                    false,
                  );
                } catch (e) {
                  debugPrint('Erreur de déconnexion : $e');
                  showErrorPopupComponent(
                    context,
                    title: 'Erreur',
                    message: 'Une erreur est survenue lors de la déconnexion.',
                  );
                }
              }
            },
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text(
              "Déconnexion",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.red.shade300),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
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
          activeThumbColor: Colors.orange.shade700,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
