import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';

class InformationComptePage extends StatelessWidget {
  const InformationComptePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

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
          "Informations du compte",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --------------------------------------------------
          // 🔹 HEADER
          // --------------------------------------------------
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 254, 171, 46),
                  Color.fromARGB(255, 255, 90, 40),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_outline, size: 34, color: Colors.white),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    user != null
                        ? "Voici les informations liées à votre compte"
                        : "Vous êtes actuellement en mode invité",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // --------------------------------------------------
          // 🔹 INFOS UTILISATEUR
          // --------------------------------------------------
          _infoTile(
            icon: Icons.badge_outlined,
            title: "Nom",
            value: user?['name']?.toString() ?? "Invité",
          ),

          _infoTile(
            icon: Icons.email_outlined,
            title: "Email",
            value: user?['email']?.toString() ?? "Non renseigné",
          ),

          _infoTile(
            icon: Icons.phone_outlined,
            title: "Téléphone",
            value: user?['phone']?.toString() ?? "Non renseigné",
          ),

          const SizedBox(height: 24),

          // --------------------------------------------------
          // 🔹 STATUT COMPTE
          // --------------------------------------------------
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: user != null
                  ? const Color(0xFFD8FFE5)
                  : const Color(0xFFFFE0E0),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Icon(
                  user != null
                      ? Icons.verified_user_outlined
                      : Icons.info_outline,
                  color: user != null ? Colors.green : Colors.redAccent,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    user != null
                        ? "Compte actif • Accès complet aux fonctionnalités"
                        : "Mode invité • Certaines fonctionnalités sont limitées",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // --------------------------------------------------
          // 🔹 ACTIONS
          // --------------------------------------------------
          if (user == null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Get.toNamed('/inscription_choice'),
                icon: const Icon(Icons.login, color: Colors.black),
                label: const Text(
                  "Créer un compte / Se connecter",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Get.toNamed('/Gerer_compte'),
                icon: const Icon(Icons.manage_accounts, color: Colors.black),
                label: const Text(
                  "Gérer mon compte",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),

          // Positionner tout en bas et responsive a tout type d'ecran
          const SizedBox(height: 30),

          Center(
            child: Text(
              "DrinkEasy • Informations personnelles",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // 🔹 INFO TILE
  // --------------------------------------------------
  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.orange.shade700),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
