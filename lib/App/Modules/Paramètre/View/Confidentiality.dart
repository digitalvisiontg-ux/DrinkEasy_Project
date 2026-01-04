import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfidentialityPage extends StatelessWidget {
  const ConfidentialityPage({super.key});

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
          "Confidentialité",
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
          // 🔐 HEADER
          // --------------------------------------------------
          Container(
            padding: const EdgeInsets.all(18),
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
              children: const [
                Icon(Icons.lock_outline_rounded, size: 34, color: Colors.white),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    "Votre confidentialité est importante.\nNous protégeons vos données.",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),
          _section("Données collectées"),

          _infoTile(
            icon: Icons.person_outline,
            title: "Informations personnelles",
            content:
                "Nous collectons uniquement les informations nécessaires au fonctionnement du service (nom, téléphone ou email).",
          ),

          _infoTile(
            icon: Icons.restaurant_menu,
            title: "Données de commande",
            content:
                "Les commandes sont utilisées uniquement pour le service à table et l’historique utilisateur.",
          ),

          const SizedBox(height: 22),
          _section("Utilisation des données"),

          _infoTile(
            icon: Icons.settings_outlined,
            title: "Fonctionnement de l’application",
            content:
                "Vos données permettent de gérer les commandes, le service en salle et l’assistance client.",
          ),

          _infoTile(
            icon: Icons.bar_chart_outlined,
            title: "Statistiques internes",
            content:
                "Des données anonymes peuvent être utilisées pour améliorer l’expérience utilisateur.",
          ),

          const SizedBox(height: 22),
          _section("Sécurité"),

          _infoTile(
            icon: Icons.security_outlined,
            title: "Protection",
            content:
                "Vos données sont protégées et ne sont jamais revendues à des tiers.",
          ),

          _infoTile(
            icon: Icons.visibility_off_outlined,
            title: "Confidentialité",
            content:
                "Seules les personnes autorisées peuvent accéder aux informations nécessaires au service.",
          ),

          const SizedBox(height: 22),
          _section("Vos droits"),

          _infoTile(
            icon: Icons.edit_outlined,
            title: "Modification",
            content:
                "Vous pouvez modifier ou supprimer vos informations depuis votre compte.",
          ),

          _infoTile(
            icon: Icons.delete_outline,
            title: "Suppression du compte",
            content:
                "La suppression de votre compte entraîne la suppression définitive de vos données.",
          ),

          const SizedBox(height: 22),
          Center(
            child: Text(
              "DrinkEasy • Politique de confidentialité",
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
  // 🔹 SECTION TITLE
  // --------------------------------------------------
  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 🔹 INFO TILE
  // --------------------------------------------------
  Widget _infoTile({
    required IconData icon,
    required String title,
    required String content,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 5),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
